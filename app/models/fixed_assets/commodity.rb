class FixedAssets::Commodity < ActiveRecord::Base
  include Searchable

  belongs_to :company
  has_one :voucher, class_name: 'Head::Voucher'
  has_many :commodity_rows
  has_many :procurement_rows, class_name: 'Head::VoucherRow'

  attr_accessor :generate_rows

  before_validation :create_bookkeepping_rows, on: [:update], if: :should_create_rows?

  def get_options_for_type
    [
      ['Valitse',''],
      ['Tasapoisto kuukausittain','T'],
      ['Tasapoisto vuosiprosentti','P'],
      ['Menojäännöspoisto vuosiprosentti','B']
    ]
  end

  def get_options_for_status
    [
      ['Ei aktivoitu', ''],
      ['Aktivoitu', 'A'],
      ['Poistettu', 'P']
    ]
  end

  def lock_all_rows
    commodity_rows.update_all(locked: true)
    voucher.rows.update_all(lukko: "X")
  end

  # Calculates monthly payments within fiscal year
  def divide_to_payments(full_amount, full_count)
    full_amount = full_amount.to_d
    return [] if full_amount.zero? || full_count.zero?

    fiscal_year = company.get_months_in_current_fiscal_year

    fiscal_maximum = full_amount / full_count * fiscal_year
    fiscal_maximum = fiscal_maximum.ceil

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
      if remainder[0] < fiscal_year
        result << remainder[1]
      else
        result[-1] += remainder[1]
      end
    end

    result
  end

  def fixed_by_percentage(full_amount, calculation_amount)
    yearly_amount = full_amount * calculation_amount / 100
    payments = full_amount / yearly_amount * 12
    payments = payments.to_i
    divide_to_payments(full_amount, payments)
  end

  def degressive_by_percentage(full_amount, fiscal_percentage, depreciated_amount = 0)
    one_year = company.get_months_in_current_fiscal_year
    full_amount = full_amount.to_d

    # Sum the value of previous fiscal reductions
    full_amount = full_amount - depreciated_amount

    fiscal_percentage = fiscal_percentage.to_d / 100
    fiscal_year_depreciations = []
    first_depreciation = full_amount * fiscal_percentage / one_year

    fiscal_year_depreciations << first_depreciation.to_i

    fiscalreduction = full_amount * fiscal_percentage
    keep_running = true

    while keep_running do
      injecthis = (full_amount - fiscal_year_depreciations.sum) * fiscal_percentage / one_year

      if fiscal_year_depreciations.count == one_year - 1
        injecthis = fiscalreduction - fiscal_year_depreciations.sum
        keep_running = false
      end
      injecthis = injecthis.to_i

      fiscal_year_depreciations << injecthis unless injecthis.zero?
    end

    fiscal_year_depreciations
  end

  def fixed_by_month(full_amount, total_number_of_payments, depreciated_payments = 0, depreciated_amount = 0)

    fiscal_length = company.get_months_in_current_fiscal_year
    remaining_payments = total_number_of_payments - depreciated_payments
    remaining_amount = full_amount - depreciated_amount

    fiscal_maximum = full_amount.to_d / total_number_of_payments * fiscal_length
    fiscal_maximum = fiscal_maximum.ceil

    if remaining_amount > fiscal_maximum
      remaining_amount = fiscal_maximum
    end

    # Calculate fiscal payments
    if remaining_payments >= fiscal_length
      divide_to_payments(remaining_amount, fiscal_length)
    else
      divide_to_payments(remaining_amount, remaining_payments)
    end
  end

  private

    def activated?
      status == 'A'
    end

    def should_create_rows?
      generate_rows && activated?
    end

    def create_bookkeepping_rows
      create_voucher if voucher.nil?
      create_planned_depreciation_rows
      create_btl_depreciation_rows
    end

    def create_voucher
      tilikausi = company.get_fiscal_year

      voucher_params = {
        nimi: "Poistoerätosite tilikaudelta #{tilikausi.first}-#{tilikausi.last}",
        laatija: created_by,
        muuttaja: modified_by,
        commodity_id: id
      }

      accounting_voucher = company.vouchers.build(voucher_params)
      accounting_voucher.save

      self.voucher = accounting_voucher
    end

    def create_planned_depreciation_rows
      planned_rows = create_depreciation_rows(:planned_depreciation)
      planned_rows.each do |params|
        # Only create rows for current fiscal year
        if company.is_date_in_this_fiscal_year?(params[:transacted_at])
          row_params = {
            laatija: params[:created_by],
            tapvm: params[:transacted_at],
            summa: params[:amount],
            yhtio: params[:yhtio],
            selite: params[:description],
            tilino: params[:account]
          }

          voucher.rows.create(row_params)
        end
      end
      # Trigger autosave
      voucher.save
    end

    def create_btl_depreciation_rows
      btl_rows = create_depreciation_rows(:btl_depreciation)
      btl_rows.each do |params|
        # Only create rows for current fiscal year
        if company.is_date_in_this_fiscal_year?(params[:transacted_at])
          build_commodity_row(params)
        end
      end
    end

    def build_commodity_row(params)
      params.delete :yhtio
      commodity_rows.build params
    end

    def create_depreciation_rows(depreciation_type)
      case depreciation_type
      when :planned_depreciation
        calculation_type = planned_depreciation_type
        calculation_amount = planned_depreciation_amount
        depreciated_sum = voucher.rows.sum(:summa)
        depreciation_amount = voucher.rows.count
      when :btl_depreciation
        calculation_type = btl_depreciation_type
        calculation_amount = btl_depreciation_amount
        depreciated_sum = commodity_rows.sum(:amount)
        depreciation_amount = commodity_rows.count
      else
        raise ArgumentError, 'Invalid depreciation_type'
      end

      # Calculation rules
      case calculation_type
      when 'T'
        # Fixed by months
        calculated_depreciations = fixed_by_month(amount, calculation_amount, depreciation_amount, depreciated_sum)
      when 'P'
        # Fixed by percentage
        calculated_depreciations = fixed_by_percentage(amount, calculation_amount)
      when 'B'
        # Degressive by percentage
        calculated_depreciations = degressive_by_percentage(amount, calculation_amount, depreciated_sum)
      else
        raise ArgumentError, 'Invalid calculation_type'
      end

      activation_date = self.activated_at
      all_row_params = []

      amt = 0
      calculated_depreciations.each do |red|
        time = activation_date.advance(months: +amt)

        all_row_params << {
          yhtio: company.yhtio,
          created_by: created_by,
          modified_by: modified_by,
          transacted_at: time.end_of_month,
          amount: red,
          description: "#{depreciation_type}",
          account: procurement_rows.first.tilino
        }

        amt += 1
      end

      all_row_params
    end
end
