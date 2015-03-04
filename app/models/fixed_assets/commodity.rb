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
  validate :activation_only_on_open_fiscal_year, if: :activated?
  validate :depreciation_amount_must_follow_type, if: :activated?
  validate :must_have_procurement_rows, if: :activated?

  before_save :set_amount

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

  def ok_to_generate_rows?
    activated? && important_values_changed?
  end

  def generate_rows
    mark_rows_obsolete
    generate_voucher_rows
    generate_commodity_rows
    generate_depreciation_difference_rows
  end

  # Sopivat ostolaskut
  def linkable_invoices
    company.purchase_invoices_paid.find_by_account(viable_accounts)
  end

  # Sopivat tositteet
  def linkable_vouchers
    company.vouchers.commodity_linkable.find_by_account(viable_accounts)
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
    procurement_row.try(:tilino)
  end

  def procurement_cost_centre
    procurement_row.try(:kustp)
  end

  def procurement_project
    procurement_row.try(:projekti)
  end

  def procurement_target
    procurement_row.try(:kohde)
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

    def mark_rows_obsolete
      commodity_rows.update_all(amended: true)
      voucher.rows.update_all(korjattu: "X", korjausaika: Time.now) if voucher.present?
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
      unless company.date_in_open_period?(activated_at)
        errors.add(:base, "Activation date must be within current editable fiscal year")
      end
    end

    def only_one_account_number
      if procurement_rows.map(&:tilino).uniq.count > 1
        errors.add(:base, "Account number must be shared between all linked cost records")
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
      amounts = calculate_depreciations(:SUMU)

      # Poistoerän kirjaus
      amounts.each_with_index do |amount, i|
        time = depreciation_start_date.advance(months: +i)

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
      amounts = calculate_depreciations(:EVL)

      amounts.each_with_index do |amount, i|
        time = depreciation_start_date.advance(months: +i)

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

      @generator = CommodityRowGenerator.new(commodity_id: id)

      # Calculation rules
      case calculation_type.to_sym
      when :T
        # Tasapoisto kuukausittain
        @generator.fixed_by_month(amount, calculation_amount, depreciation_amount, depreciated_sum)
      when :P
        # Tasapoisto vuosiprosentti
        @generator.fixed_by_percentage(amount, calculation_amount)
      when :B
        # Menojäännöspoisto vuosiprosentti
        @generator.degressive_by_percentage(amount, calculation_amount, depreciated_sum)
      else
        raise ArgumentError, 'Invalid calculation_type'
      end
    end

    def depreciation_start_date
      current_start = company.current_fiscal_year.first
      return current_start if activated_at < current_start
      activated_at
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

    def viable_accounts
      # Jos tili on valittu, käytetään sitä. Muuten kaikki EVL tilit
      procurement_row ? procurement_number : company.accounts.evl_accounts.select(:tilino)
    end

    def set_amount
      self.amount = procurement_row.present? ? procurement_rows.sum(:summa) : 0.0
    end

    def must_have_procurement_rows
      unless procurement_row.present?
        errors.add(:base, 'Must have procurement rows if activated')
      end
    end
end
