class FixedAssets::Commodity < ActiveRecord::Base
  include Searchable

  # commodity = hyödyke
  # .voucher = tosite, jolle kirjataan SUMU-poistot
  # .voucher.rows = tosittella on SUMU-poisto tiliöintirivejä
  # .commodity_rows = rivejä, jolla kirjataan EVL poistot
  # .procurement_rows = tiliöintirivejä, joilla on valittu hyödykkeelle kuuluvat hankinnat

  belongs_to :company
  has_one :voucher, class_name: 'Head::Voucher'
  has_many :commodity_rows
  has_many :procurement_rows, class_name: 'Head::VoucherRow'

  validates_presence_of :name, :description

  validate :only_one_account_number
  validate :cost_sum_must_match_amount, if: :activated?
  validate :activation_only_on_open_fiscal_year, if: :activated?
  validate :depreciation_amount_must_follow_type, if: :activated?

  before_save :generate_rows, if: :generate_rows?

  def self.options_for_type
    [
      ['Valitse',''],
      ['Tasapoisto kuukausittain','T'],
      ['Tasapoisto vuosiprosentti','P'],
      ['Menojäännöspoisto vuosiprosentti','B']
    ]
  end

  def self.options_for_status
    [
      ['Ei aktivoitu', ''],
      ['Aktivoitu', 'A'],
      ['Poistettu', 'P']
    ]
  end

  # Sopivat ostolaskut
  def linkable_invoices
    result = []
    if procurement_row.present?
      logger.debug("Linkable purchase invoices when acct chosen: #{company.purchase_invoices_paid.count}")
      company.purchase_invoices_paid
    else
      logger.debug("Linkable purchase invoices when acct not chosen: #{company.purchase_invoices_paid.count}")
      company.purchase_invoices_paid
    end

    #result
  end

  # Sopivat tositteet
  def linkable_vouchers
    result = []
    if procurement_row.present?
      logger.debug("Linkable vouchers when acct chosen: #{company.vouchers.commodity_linkable.count}")
      # Tilinumero jo valittu
      company.vouchers.commodity_linkable.each { |x| result << x if x.linkable_rows(procurement_number).count > 0 }
    else
      logger.debug("Linkable vouchers when no acct chosen: #{company.vouchers.commodity_linkable.count}")
      # Tilinumeroa ei valittu
      company.vouchers.commodity_linkable.each { |x| result << x if x.rows.map(&:linkable?).any? }
    end

    result
  end

  # Poistorivit
  def depreciation_rows
    voucher.rows.where(tilino: procurement_number)
  end

  # Poistoerorivit
  def difference_rows
    voucher.rows.where(tilino: poistoero_number)
  end

  # Poistovastarivit
  def counter_depreciation_rows
    voucher.rows.where(tilino: planned_counter_number)
  end

  # Poistoerovastarivit
  def counter_difference_rows
    voucher.rows.where(tilino: difference_counter_number)
  end

  # Poistoerorivit tietyllä aikavälillä
  def difference_rows_between(date1, date2)
    difference_rows.where(tapvm: date1..date2)
  end

  def activated?
    status == 'A'
  end

  def lock_rows
    commodity_rows.update_all(locked: true)
    voucher.rows.update_all(lukko: "X")
  end

  # Returns sum of past sumu depreciations
  def deprecated_sumu_amount
    voucher.rows.locked.sum(:summa)
  end

  # Returns sum of past evl depreciations
  def deprecated_evl_amount
    commodity_rows.locked.sum(:amount)
  end

  def procurement_number
    return 0 if procurement_row.nil?
    procurement_row.tilino
  end

  def procurement_cost_centre
    return 0 if procurement_row.nil?
    procurement_row.kustp
  end

  def procurement_project
    return 0 if procurement_row.nil?
    procurement_row.projekti
  end

  def procurement_target
    return 0 if procurement_row.nil?
    procurement_row.kohde
  end

  def procurement_row
    procurement_rows.first
  end

  def poistoero_number
    procurement_sumlevel.poistoero_account.tilino
  end

  def planned_counter_number
    procurement_sumlevel.poistovasta_account.tilino
  end

  def difference_counter_number
    procurement_sumlevel.poistoerovasta_account.tilino
  end

  # Calculates monthly payments within fiscal year
  def divide_to_payments(full_amount, full_count, max_fiscal_reduction = 0)
    # full_amount = hydykkeen hankintahinta
    # full_count = kokonaispoistoaika kuukausissa
    # max_fiscal_reduction = tasapoisto vuosiprosentille laskettu tilikauden maksimi
    full_amount = full_amount.to_d
    return [] if full_amount.zero? || full_count.zero?

    fiscal_maximum = full_amount / full_count * payment_count
    fiscal_maximum = fiscal_maximum.ceil

    if max_fiscal_reduction > 0 && fiscal_maximum > max_fiscal_reduction
      fiscal_maximum = max_fiscal_reduction
    end

    payment_amount = full_amount / full_count
    payment_amount = payment_amount.round(2)

    if full_amount > fiscal_maximum
      full_amount = fiscal_maximum
    end

    remainder = full_amount.divmod(payment_amount)

    result = []

    remainder[0].to_i.times do
      result << payment_amount
    end

    unless remainder[1].zero?
      if remainder[0] < payment_count
        result << remainder[1]
      else
        result[-1] += remainder[1]
      end
    end

    result
  end

  def fixed_by_percentage(full_amount, percentage)
    # full_amount = hydykkeen hankintahinta
    # percentage = vuosipoistoprosentti
    yearly_amount = full_amount * percentage / 100
    payments = full_amount / yearly_amount * payment_count
    payments = payments.to_i
    divide_to_payments(full_amount, payments, yearly_amount)
  end

  def degressive_by_percentage(full_amount, fiscal_percentage, depreciated_amount = 0)
    # full_amount = hydykkeen hankintahinta
    # fiscal_percentage = vuosipoistoprosentti
    # depreciated_amount = jo poistettu summa
    full_amount = full_amount.to_d

    # Sum the value of previous fiscal reductions
    full_amount = full_amount - depreciated_amount

    fiscal_percentage = fiscal_percentage.to_d / 100
    fiscal_year_depreciations = []
    first_depreciation = full_amount * fiscal_percentage / payment_count

    fiscal_year_depreciations << first_depreciation.to_i

    fiscalreduction = full_amount * fiscal_percentage
    keep_running = true

    while keep_running do
      injecthis = (full_amount - fiscal_year_depreciations.sum) * fiscal_percentage / payment_count

      if fiscal_year_depreciations.count == payment_count - 1
        injecthis = fiscalreduction - fiscal_year_depreciations.sum
        keep_running = false
      end
      injecthis = injecthis.to_i

      fiscal_year_depreciations << injecthis unless injecthis.zero?
    end

    fiscal_year_depreciations
  end

  def fixed_by_month(full_amount, total_number_of_payments, depreciated_payments = 0, depreciated_amount = 0)
    # full_amount = hydykkeen hankintahinta
    # total_number_of_payments = poistojen kokonaismäärä kuukausissa
    # depreciated_payments = jo poistettujen erien lukumäärä
    # depreciated_amount = jo poistettu summa
    remaining_payments = total_number_of_payments - depreciated_payments
    remaining_amount = full_amount - depreciated_amount

    fiscal_maximum = full_amount.to_d / total_number_of_payments * payment_count
    fiscal_maximum = fiscal_maximum.ceil

    if remaining_amount > fiscal_maximum
      remaining_amount = fiscal_maximum
    end

    # Calculate fiscal payments
    if remaining_payments >= payment_count
      divide_to_payments(remaining_amount, payment_count)
    else
      divide_to_payments(remaining_amount, remaining_payments)
    end
  end

  private

    def important_values_changed?
      attrs = %w{
        amount
        activated_at
        planned_depreciation_type
        planned_depreciation_amount
        btl_depreciation_type
        btl_depreciation_amount
      }

      (changed & attrs).any?
    end

    def generate_rows?
      activated? && important_values_changed?
    end

    def mark_rows_obsolete
      commodity_rows.update_all(amended: true)
      voucher.rows.update_all(korjattu: "X", korjausaika: Time.now) if voucher.present?
    end

    def generate_rows
      mark_rows_obsolete
      generate_voucher_rows
      generate_commodity_rows
      generate_depreciation_difference_rows
    end

    def depreciation_amount_must_follow_type
      check_amount_allowed_for_type(planned_depreciation_type, planned_depreciation_amount)
      check_amount_allowed_for_type(btl_depreciation_type, btl_depreciation_amount)
    end

    def check_amount_allowed_for_type(type, amount)
      type = type.to_sym

      case type
      when :T
        errors.add(type, "Must be a positive number") if amount < 0
      when :P, :B
        errors.add(type, "Must be between 1-100") if amount <= 0 || amount > 100
      end
    end

    def activation_only_on_open_fiscal_year
      unless company.date_in_current_fiscal_year?(activated_at)
        errors.add(:base, "Activation date must be within current editable fiscal year")
      end
    end

    def only_one_account_number
      if procurement_rows.map(&:tilino).uniq.count > 1
        errors.add(:base, "Account number must be shared between all linked cost records")
      end
    end

    def cost_sum_must_match_amount
      procurement_sum = procurement_rows.sum(:summa)
      unless amount == procurement_sum
        errors.add(:base, "Commodity amount #{amount} must match sum of all cost records #{procurement_sum}")
      end
    end

    def create_voucher
      voucher_params = {
        nimi: "Poistoerätosite hyödykkeelle #{name}: #{id}",
        laatija: created_by,
        muuttaja: modified_by,
        commodity_id: id
      }

      accounting_voucher = company.vouchers.build(voucher_params)
      accounting_voucher.save!

      self.voucher = accounting_voucher
    end

    def generate_voucher_rows
      create_voucher if voucher.nil?
      activation_date = activated_at
      amounts = calculate_depreciations(:SUMU)

      # Poistoerän kirjaus
      amounts.each_with_index do |amount, i|
        time = activation_date.advance(months: +i)

        row_params = {
          laatija: created_by,
          tapvm: time.end_of_month,
          summa: amount,
          yhtio: company.yhtio,
          selite: :SUMU,
          tilino: procurement_number
        }

        row = voucher.rows.create!(row_params)

        # Poistoerän vastakirjaus
        row.counter_entry(planned_counter_number)
      end
    end

    def generate_commodity_rows
      activation_date = activated_at
      amounts = calculate_depreciations(:EVL)

      amounts.each_with_index do |amount, i|
        time = activation_date.advance(months: +i)

        row_params = {
          created_by: created_by,
          modified_by: modified_by,
          transacted_at: time.end_of_month,
          amount: amount,
          description: :EVL,
          account: procurement_number
        }

        commodity_rows.create!(row_params)
      end
    end

    def generate_depreciation_difference_rows
      # Poistoeron kirjaus
      depreciation_differences.each do |md|
        amount = md.first
        time = md.last

        row_params = {
          laatija: created_by,
          tapvm: time,
          summa: amount,
          yhtio: company.yhtio,
          selite: 'poistoerokirjaus',
          tilino: poistoero_number
        }

        row = voucher.rows.create!(row_params)

        # Poistoeron vastakirjaus
        row.counter_entry(difference_counter_number)
      end
    end

    def calculate_depreciations(depreciation_type)
      case depreciation_type.to_sym
      when :SUMU
        calculation_type = planned_depreciation_type
        calculation_amount = planned_depreciation_amount
        depreciated_sum = deprecated_sumu_amount
        depreciation_amount = voucher.rows.count
      when :EVL
        calculation_type = btl_depreciation_type
        calculation_amount = btl_depreciation_amount
        depreciated_sum = deprecated_evl_amount
        depreciation_amount = commodity_rows.count
      else
        raise ArgumentError, 'Invalid depreciation_type'
      end

      # Calculation rules
      case calculation_type.to_sym
      when :T
        # Tasapoisto kuukausittain
        fixed_by_month(amount, calculation_amount, depreciation_amount, depreciated_sum)
      when :P
        # Tasapoisto vuosiprosentti
        fixed_by_percentage(amount, calculation_amount)
      when :B
        # Menojäännöspoisto vuosiprosentti
        degressive_by_percentage(amount, calculation_amount, depreciated_sum)
      else
        raise ArgumentError, 'Invalid calculation_type'
      end
    end

    def payment_count
      current_active = company.months_in_current_fiscal_year
      return current_active if activated_at < company.fiscal_year.first
      (activated_at..company.fiscal_year.last).map(&:end_of_month).uniq.count
    end

    def depreciation_differences
      commodity_rows.map { |evl| [evl.depreciation_difference, evl.transacted_at] }
    end

    def procurement_account
      company.accounts.find_by(tilino: procurement_number)
    end

    def procurement_sumlevel
      procurement_account.commodity
    end
end
