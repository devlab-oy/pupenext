class FixedAssets::Commodity < ActiveRecord::Base
  include Searchable

  belongs_to :company
  has_one :voucher, class_name: 'Head::Voucher'
  has_many :commodity_rows
  has_many :procurement_rows, class_name: 'Head::VoucherRow'

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

    remainder[0].to_i.times do |k|
      result[k] = payment_amount
    end

    unless remainder[1].zero?
      if remainder[0] < full_count
        result.push remainder[1]
      else
        result[-1] += remainder[1]
      end
    end

    result
  end

  def degressive_by_fiscal_percentage(full_amount, fiscal_percentage, depreciated_amount = 0)
    one_year = company.get_months_in_current_fiscal_year
    full_amount = full_amount.to_d

    # Sum the value of previous fiscal reductions
    full_amount = full_amount - depreciated_amount

    fiscal_percentage = fiscal_percentage.to_d / 100
    fiscal_year_depreciations = []
    first_depreciation = full_amount * fiscal_percentage / one_year

    fiscal_year_depreciations.push first_depreciation.to_i

    fiscalreduction = full_amount*fiscal_percentage
    keep_running = true

    while keep_running do
      injecthis = (full_amount-fiscal_year_depreciations.sum) * fiscal_percentage / one_year

      if fiscal_year_depreciations.count == one_year-1
        injecthis = fiscalreduction-fiscal_year_depreciations.sum
        keep_running = false
      end
      injecthis = injecthis.to_i

      fiscal_year_depreciations.push injecthis unless injecthis.zero?
    end

    fiscal_year_depreciations
  end

  def degressive_by_fiscal_payments(full_amount, total_number_of_payments,
    depreciated_payments = 0, depreciated_amount = 0)

    fiscal_length = company.get_months_in_current_fiscal_year
    remaining_payments = total_number_of_payments - depreciated_payments
    remaining_amount = full_amount - depreciated_amount

    fiscal_maximum = full_amount.to_d / total_number_of_payments * fiscal_length
    fiscal_maximum = fiscal_maximum.ceil

    result = []

    if remaining_amount > fiscal_maximum
      remaining_amount = fiscal_maximum
    end

    # Calculate fiscal payments
    if remaining_payments >= fiscal_length
      result = divide_to_payments(remaining_amount, fiscal_length)
    else
      result = divide_to_payments(remaining_amount, remaining_payments)
    end

    result
  end

  def divide_to_degressive_payments_by_months(full_amount, months)
    total_number_of_payments = months
    one_year = company.get_months_in_current_fiscal_year

    result = []
    # Calculate first year
    first_year_reductions = divide_to_payments(full_amount, total_number_of_payments)
    result = first_year_reductions.take(one_year)
    remaining_payments = total_number_of_payments-one_year
    remaining_amount = full_amount - result.sum

    # Calculate the rest
    until remaining_payments.zero?
      if remaining_payments < one_year+1
        count_with_this = remaining_payments
      else
        count_with_this = total_number_of_payments
      end
      later_year_result = divide_to_payments(remaining_amount, count_with_this)

      later_result = later_year_result.take(one_year)
      remaining_payments -= later_result.count
      remaining_amount -= later_result.sum
      result.concat later_result
      remaining_amount = full_amount - result.sum

      if remaining_payments < 1
        remaining_payments = 0
        if remaining_amount > 0
          result.push remaining_amount
        end
      end
    end
    result
  end
end
