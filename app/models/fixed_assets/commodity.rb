class FixedAssets::Commodity < ActiveRecord::Base
  belongs_to :company
  has_one :voucher, foreign_key: :hyodyke_tunnus, class_name: 'Head::Voucher'
  has_many :commodity_rows

  def lock_all_rows
    commodity_rows.update_all(locked: true)
    voucher.rows.update_all(lukko: "X")
  end

  def get_options_for_type
    [
      ['Valitse',''],
      ['Tasapoisto kuukausittain','T'],
      ['Tasapoisto vuosiprosentti','P'],
      ['Menojäännöspoisto kuukausittain','D'],
      ['Menojäännöspoisto vuosiprosentti','B']
    ]
  end

  def get_options_for_state
    [
      ['Ei aktivoitu', ''],
      ['Aktivoitu', 'A'],
      ['Poistettu', 'P']
    ]
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

  def divide_to_degressive_payments_by_percentage(full_amount, yearly_percentage)
    one_year = company.get_months_in_current_fiscal_year
    full_amount = full_amount.to_d
    yearly_percentage = yearly_percentage.to_d / 100
    payments = []
    zoidberg = full_amount * yearly_percentage / one_year
    payments.push zoidberg.to_i

    keep_running = true

    while keep_running do
      injecthis = (full_amount-payments.sum) * yearly_percentage / one_year
      if injecthis < 10 #Maybe accountant could give this minimum from the view?
        injecthis = full_amount-payments.sum
        keep_running = false
      end
      injecthis = injecthis.to_i

      payments.push injecthis
    end

    payments
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

  private

    def activated?
      tila == 'A'
    end

    def should_create_rows?
      generate_rows && activated?
    end

    def has_linked_accounting_rows?
      cost_rows.count > 0
    end

    def create_bookkeepping_rows
      create_voucher if accounting_voucher.nil?
      create_internal_bk_rows
      create_external_bk_rows
    end

    def create_external_bk_rows
      #deactivate_old_rows unless rows.count.zero?

      external_rows = create_installment_rows(:evl)
      external_rows.each do |params|
        # Only create rows for current fiscal year
        if company.is_date_in_this_fiscal_year?(params[:tapvm])
          create_row(params)
        end
      end
    end

    def create_internal_bk_rows
      #accounting_voucher.deactivate_old_rows unless accounting_voucher.nil?

      internal_rows = create_installment_rows(:sumu)
      internal_rows.each do |params|
        # Only create rows for current fiscal year
        if company.is_date_in_this_fiscal_year?(params[:tapvm])
          accounting_voucher.create_voucher_row(params)
        end
      end
      accounting_voucher.save
    end

    def create_voucher
      voucher_params = {
        nimi: "Poistoerätosite",
        laatija: laatija,
        muuttaja: muuttaja,
        hyodyke_tunnus: tunnus,
        tila: 'X',
        alatila: '',
        yhtio: yhtio,
        lapvm: Date.today,
        tapvm: Date.today,
        kapvm: Date.today,
        erpcm: Date.today,
        olmapvm: Date.today,
        kerayspvm: Date.today,
        muutospvm: Date.today,
        toimaika: Date.today,
        maksuaika: Date.today,
        lahetepvm: Date.today,
        laskutettu: Date.today,
        h1time: Date.today,
        h2time: Date.today,
        h3time: Date.today,
        h4time: Date.today,
        h5time: Date.today,
        mapvm: Date.today,
        popvm: Date.today,
        puh: '',
        toim_puh: '',
        email: '',
        toim_email: ''
      }
      voucher = build_accounting_voucher voucher_params
      voucher.save
    end

    def check_that_account_number_matches
      cost_rows.each do |cos|
        if cos.accounting_row.nil?
          next
        elsif cos.accounting_row.tilino != tilino
          errors.add(:cost_row, "account number mismatch - should be #{cos.accounting_row.tilino} but is #{tilino}")
        end
      end
    end

    def create_row(params)
      rows.build params
    end

    def deactivate_old_rows
      rows.active.update_all(korjattu: 'X', korjausaika: Time.now)
    end

    def create_installment_rows(payment_type)
      full_amount = summa

      depreciated_sum = BigDecimal.new 0

      if payment_type == :sumu
        calculation_type = sumu_poistotyyppi
        calculation_amount = sumu_poistoera
        accounting_voucher.rows.active.each { |x| depreciated_sum += x.summa }
        depreciation_amount = accounting_voucher.rows.active.count
      else
        payment_type = :evl
        calculation_type = evl_poistotyyppi
        calculation_amount = evl_poistoera
        rows.active.each { |x| depreciated_sum += x.summa }
        depreciation_amount = rows.active.count
      end

      # Switch adds correct numbers to reductions array
      reductions = []

      # Calculation rules
      case calculation_type
      when 'T'
        # Fixed by months
        #reductions = divide_to_payments(full_amount, calculation_amount)
        reductions = degressive_by_fiscal_payments(full_amount, calculation_amount,
          depreciation_amount, depreciated_sum)
      when 'P'
        # Fixed by percentage
        yearly_amount = full_amount * calculation_amount / 100
        payments = full_amount / yearly_amount * 12
        payments = payments.to_i
        reductions = divide_to_payments(full_amount, payments)

      when 'D'
        # Degressive by months
        #reductions = divide_to_payments(full_amount, calculation_amount)
        reductions = degressive_by_fiscal_payments(full_amount, calculation_amount,
          depreciation_amount, depreciated_sum)
      when 'B'
        # Degressive by percentage
        reductions = degressive_by_fiscal_percentage(full_amount, calculation_amount, depreciated_sum)
      end

      activation_date = self.kayttoonottopvm
      all_row_params = []

      amt = 0
      reductions.each do |red|
        time = activation_date.advance(:months => +amt)
        all_row_params<<{
          laatija: laatija,
          muuttaja: muuttaja,
          tapvm: time.end_of_month,
          yhtio: yhtio,
          summa: red,
          tyyppi: sumu_poistotyyppi,
          selite: "#{payment_type} poisto",
          tilino: tilino
        }
        amt += 1
      end

      all_row_params
    end

    def set_sum_to_commodity
      totalsum = BigDecimal.new 0
      cost_rows.each {|x| totalsum += x.accounting_row.summa rescue 0 }
      summa = totalsum
    end
end
