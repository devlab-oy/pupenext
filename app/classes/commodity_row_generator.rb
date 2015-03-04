class CommodityRowGenerator
  attr_accessor :company, :commodity, :fiscal_start, :fiscal_end, :activation_date

  def initialize(commodity_id:, fiscal_start: nil, fiscal_end: nil)
    self.commodity       = FixedAssets::Commodity.find(commodity_id)
    self.company         = commodity.company
    self.activation_date = commodity.activated_at
    self.fiscal_start    = fiscal_start || company.current_fiscal_year.first
    self.fiscal_end      = fiscal_end || company.current_fiscal_year.last
  end

  def generate_rows
    mark_rows_obsolete
    generate_voucher_rows
    generate_commodity_rows
    generate_depreciation_difference_rows
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

    def depreciation_start_date
      fiscal_period.cover?(activation_date) ? activation_date : fiscal_start
    end

    def fiscal_period
      fiscal_start..fiscal_end
    end

    def calculation_period
      depreciation_start_date..fiscal_end
    end

    def payment_count
      calculation_period.map(&:end_of_month).uniq.count
    end

    def mark_rows_obsolete
      commodity.commodity_rows.where(transacted_at: fiscal_period).update_all(amended: true)
      commodity.voucher.rows.where(tapvm: fiscal_period).update_all(korjattu: "X", korjausaika: Time.now) if commodity.voucher.present?
    end

    def create_voucher
      voucher_params = {
        nimi: "Poistoerätosite hyödykkeelle #{commodity.name}",
        laatija: commodity.created_by,
        muuttaja: commodity.modified_by,
        commodity_id: commodity.id
      }

      accounting_voucher = company.vouchers.build(voucher_params)
      accounting_voucher.save!

      commodity.voucher = accounting_voucher
      commodity.save!
    end

    def generate_voucher_rows
      create_voucher if commodity.voucher.nil?
      amounts = calculate_depreciations(:SUMU)

      # Poistoerän kirjaus
      amounts.each_with_index do |amount, i|
        time = depreciation_start_date.advance(months: +i)

        row_params = {
          laatija: commodity.created_by,
          tapvm: time.end_of_month,
          summa: amount,
          yhtio: company.yhtio,
          selite: "SUMU poisto, tyyppi: #{commodity.planned_depreciation_type}, erä: #{commodity.planned_depreciation_amount}",
          tilino: commodity.procurement_number
        }

        row = commodity.voucher.rows.create!(row_params)

        # Poistoerän vastakirjaus
        row.counter_entry(commodity.planned_counter_number)
      end
    end

    def generate_commodity_rows
      amounts = calculate_depreciations(:EVL)

      amounts.each_with_index do |amount, i|
        time = depreciation_start_date.advance(months: +i)

        row_params = {
          created_by: commodity.created_by,
          modified_by: commodity.modified_by,
          transacted_at: time.end_of_month,
          amount: amount,
          description: "EVL poisto, tyyppi: #{commodity.btl_depreciation_type}, erä: #{commodity.btl_depreciation_amount}",
          account: commodity.procurement_number
        }

        commodity.commodity_rows.create!(row_params)
      end
    end

    def generate_depreciation_difference_rows
      # Poistoeron kirjaus
      depreciation_differences.each do |amount, time|
        row_params = {
          laatija: commodity.created_by,
          tapvm: time,
          summa: amount,
          yhtio: company.yhtio,
          selite: 'poistoerokirjaus',
          tilino: commodity.poistoero_number
        }

        row = commodity.voucher.rows.create!(row_params)

        # Poistoeron vastakirjaus
        row.counter_entry(commodity.difference_counter_number)
      end
    end

    def calculate_depreciations(depreciation_type)
      case depreciation_type.to_sym
      when :SUMU
        calculation_type = commodity.planned_depreciation_type
        calculation_amount = commodity.planned_depreciation_amount
        depreciated_sum = commodity.deprecated_sumu_amount
        depreciation_amount = commodity.voucher.rows.count
      when :EVL
        calculation_type = commodity.btl_depreciation_type
        calculation_amount = commodity.btl_depreciation_amount
        depreciated_sum = commodity.deprecated_evl_amount
        depreciation_amount = commodity.commodity_rows.count
      else
        raise ArgumentError, 'Invalid depreciation_type'
      end

      # Calculation rules
      case calculation_type.to_sym
      when :T
        # Tasapoisto kuukausittain
        fixed_by_month(commodity.amount, calculation_amount, depreciation_amount, depreciated_sum)
      when :P
        # Tasapoisto vuosiprosentti
        fixed_by_percentage(commodity.amount, calculation_amount)
      when :B
        # Menojäännöspoisto vuosiprosentti
        degressive_by_percentage(commodity.amount, calculation_amount, depreciated_sum)
      else
        raise ArgumentError, 'Invalid calculation_type'
      end
    end

    def depreciation_differences
      commodity.commodity_rows.where(transacted_at: fiscal_period).map { |evl| [evl.depreciation_difference, evl.transacted_at] }
    end
end
