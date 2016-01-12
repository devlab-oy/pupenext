class CommodityRowGenerator
  attr_accessor :company, :commodity, :fiscal_start, :fiscal_end, :activation_date, :user

  def initialize(commodity_id:, fiscal_id: nil, user_id:)
    self.commodity       = FixedAssets::Commodity.find(commodity_id)
    self.company         = commodity.company
    self.activation_date = commodity.activated_at
    self.user            = company.users.find_by(tunnus: user_id)

    Current.user         = user
    Current.company      = company

    # If fiscal id not given, use open period
    fi = fiscal_id ? company.fiscal_years.find(fiscal_id).period : company.open_period
    self.fiscal_start = fi.first
    self.fiscal_end   = fi.last

    raise ArgumentError unless commodity.activated?
    raise ArgumentError unless commodity.valid?
    raise ArgumentError unless company.date_in_open_period?(depreciation_start_date)
    raise ArgumentError unless company.date_in_open_period?(fiscal_end)
    raise ArgumentError unless confirm_calculation_dates
  end

  def generate_rows
    mark_rows_obsolete
    generate_voucher_rows
    generate_commodity_rows
    generate_depreciation_difference_rows
    split_voucher_rows
  end

  def mark_rows_obsolete
    commodity.commodity_rows.where(transacted_at: fiscal_period).update_all(amended: true)

    commodity.voucher_rows.where(tapvm: fiscal_period).find_each do |row|
      row.amend_by(user)
      row.save
    end
  end

  def sell
    raise ArgumentError unless commodity.can_be_sold?
    amend_future_rows
    create_planned_sales_row
    create_sales_row
    create_sales_profit_row
    create_btl_remainder_rows

    commodity.status = 'P'
    commodity.save!
  end

  def fixed_by_percentage(full_amount, percentage)
    # full_amount = hydykkeen hankintahinta
    # percentage = vuosipoistoprosentti
    yearly_amount = full_amount * percentage / 100.0
    payments = full_amount / yearly_amount * payment_count
    payments = payments.to_i
    divide_to_payments(full_amount, payments, yearly_amount)
  end

  def degressive_by_percentage(full_amount, fiscal_percentage, depreciated_amount = 0.0)
    # full_amount = hydykkeen hankintahinta
    # fiscal_percentage = vuosipoistoprosentti
    # depreciated_amount = jo poistettu summa
    full_amount = full_amount.to_d

    # Sum the value of previous fiscal reductions
    full_amount = full_amount - depreciated_amount

    fiscal_percentage = fiscal_percentage.to_d / 100.0
    fiscal_year_depreciations = []
    first_depreciation = full_amount * fiscal_percentage / payment_count

    fiscal_year_depreciations << first_depreciation.round(2)

    fiscalreduction = full_amount * fiscal_percentage
    keep_running = true

    while keep_running do
      injecthis = (full_amount - fiscal_year_depreciations.sum) * fiscal_percentage / payment_count

      if fiscal_year_depreciations.count == payment_count - 1
        injecthis = fiscalreduction - fiscal_year_depreciations.sum
        keep_running = false
      end
      injecthis = injecthis.round(2)

      if injecthis.zero?
        keep_running = false
      else
        fiscal_year_depreciations << injecthis
      end
    end

    fiscal_year_depreciations
  end

  def fixed_by_month(full_amount, total_number_of_payments, depreciated_payments = 0.0, depreciated_amount = 0.0)
    # full_amount = hydykkeen hankintahinta
    # total_number_of_payments = poistojen kokonaismäärä kuukausissa
    # depreciated_payments = jo poistettujen erien lukumäärä
    # depreciated_amount = jo poistettu summa
    remaining_payments = total_number_of_payments - depreciated_payments
    remaining_amount = full_amount - depreciated_amount

    fiscal_maximum = full_amount.to_d / total_number_of_payments * payment_count
    fiscal_maximum = fiscal_maximum.round(2)

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
    def divide_to_payments(full_amount, full_count, max_fiscal_reduction = 0.0)
      # full_amount = hydykkeen hankintahinta
      # full_count = kokonaispoistoaika kuukausissa
      # max_fiscal_reduction = tasapoisto vuosiprosentille laskettu tilikauden maksimi
      full_amount = full_amount.to_d
      return [] if full_amount.zero? || full_count.zero?

      fiscal_maximum = full_amount / full_count * payment_count
      fiscal_maximum = fiscal_maximum.ceil

      if max_fiscal_reduction > 0 && fiscal_maximum > max_fiscal_reduction
        fiscal_maximum = max_fiscal_reduction.round(2)
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

    def confirm_calculation_dates
      check = true
      if fiscal_start < activation_date
        check &= fiscal_period.cover?(activation_date)
      end
      check &= fiscal_end > activation_date
      check
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

    def create_voucher
      voucher_params = {
        nimi: "Poistoerätosite käyttöomaisuuden hyödykkeelle",
        comments: "Poistoerätosite hyödykkeelle: #{commodity.name} #{commodity.description}",
        laatija: commodity.created_by,
        muuttaja: commodity.modified_by
      }

      accounting_voucher = company.vouchers.build(voucher_params)
      accounting_voucher.save

      commodity.voucher = accounting_voucher
      commodity.save
    end

    def generate_voucher_rows
      create_voucher if commodity.voucher.nil?
      amounts = calculate_depreciations(:SUMU)

      # Poistoerän kirjaus
      amounts.each_with_index do |amount, i|
        time = depreciation_start_date.advance(months: +i)

        row_params = {
          laatija: user.kuka,
          tapvm: time.end_of_month,
          summa: amount * -1,
          yhtio: company.yhtio,
          selite: "SUMU poisto, tyyppi: #{commodity.planned_depreciation_type}, erä: #{commodity.planned_depreciation_amount}",
          tilino: commodity.fixed_assets_account
        }

        row = commodity.voucher.rows.create!(row_params)

        # Poistoerän vastakirjaus
        row.counter_entry(commodity.depreciation_account)
      end
    end

    def generate_commodity_rows
      amounts = calculate_depreciations(:EVL)

      amounts.each_with_index do |amount, i|
        time = depreciation_start_date.advance(months: +i)

        row_params = {
          created_by: user.kuka,
          modified_by: user.kuka,
          transacted_at: time.end_of_month,
          amount: amount * -1,
          description: "EVL poisto, tyyppi: #{commodity.btl_depreciation_type}, erä: #{commodity.btl_depreciation_amount}"
        }

        commodity.commodity_rows.create!(row_params) if date_in_calculation_period?(time)
      end
    end

    def generate_depreciation_difference_rows
      # Poistoeron kirjaus
      depreciation_differences.each do |amount, time|
        row_params = {
          laatija: user.kuka,
          tapvm: time,
          summa: amount,
          yhtio: company.yhtio,
          selite: 'poistoerokirjaus',
          tilino: commodity.depreciation_difference_account
        }

        row = commodity.voucher.rows.create!(row_params)

        # Poistoeron vastakirjaus
        row.counter_entry(commodity.depreciation_difference_change_account)
      end
    end

    def calculate_depreciations(depreciation_type)
      case depreciation_type.to_sym
      when :SUMU
        calculation_type = commodity.planned_depreciation_type
        calculation_amount = commodity.planned_depreciation_amount
        depreciated_sum = commodity.accumulated_depreciation_at(fiscal_start)
        depreciation_amount = commodity.depreciation_rows.where("tiliointi.tapvm < ?", fiscal_start).count
      when :EVL
        calculation_type = commodity.btl_depreciation_type
        calculation_amount = commodity.btl_depreciation_amount
        depreciated_sum = commodity.amount - commodity.btl_value(depreciation_start_date)
        depreciation_amount = commodity.commodity_rows.where('fixed_assets_commodity_rows.transacted_at < ?', fiscal_start).count
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
        fixed_by_percentage(commodity.bookkeeping_value(fiscal_start), calculation_amount)
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

    def rows_need_to_split?
      return true if commodity.procurement_cost_centres.count > 1
      return true if commodity.procurement_targets.count > 1
      return true if commodity.procurement_projects.count > 1
      false
    end

    def split_voucher_rows
      return unless rows_need_to_split?
      commodity.voucher.rows.each { |row| row.split(split_params) }
    end

    def split_params
      commodity.procurement_rows.map do |pcu|
        {
          percent: (pcu.summa / commodity.amount * 100.0).round(2),
          cost_centre: pcu.kustp,
          target: pcu.kohde,
          project: pcu.projekti
        }
      end
    end

    def amend_future_rows
      # Yliajaa myyntipäivän jälkeiset poistotapahtumat
      date = commodity.deactivated_at
      commodity.commodity_rows.where("fixed_assets_commodity_rows.transacted_at > ?", date).update_all(amended: true)
      commodity.voucher.rows.where("tiliointi.tapvm > ?", date).find_each { |r| r.amend_by(user) }
    end

    def create_planned_sales_row
      # SUMU-tilin nollaus
      plannedparams = {
        laatija: user.kuka,
        tapvm: commodity.deactivated_at,
        summa: commodity.amount + commodity.fixed_assets_rows.sum(:summa),
        yhtio: company.yhtio,
        selite: "Hyödykkeen #{commodity.id} SUMU myyntikirjaus",
        tilino: commodity.fixed_assets_account
      }
      commodity.voucher.rows.create! plannedparams
    end

    def create_sales_row
      # Myyntisumma
      soldparams = {
        laatija: user.kuka,
        tapvm: commodity.deactivated_at,
        summa: commodity.amount_sold,
        yhtio: company.yhtio,
        selite: "Hyödykkeen #{commodity.id} myynti",
        tilino: commodity.sales_account.tilino
      }
      commodity.voucher.rows.create! soldparams
    end

    def create_sales_profit_row
      # Myyntivoitto/tappio
      profitparams = {
        laatija: user.kuka,
        tapvm: commodity.deactivated_at,
        summa: commodity.amount - commodity.amount_sold,
        yhtio: company.yhtio,
        selite: "Hyödykkeen #{commodity.id} myyntivoitto/tappio",
        tilino: commodity.profit_account.tilino
      }
      commodity.voucher.rows.create! profitparams
    end

    def create_btl_remainder_rows
      case commodity.depreciation_remainder_handling
      when 'S'
      # Evl arvo nollaan, kirjataan jäljelläoleva arvo pois
      btl_dep_value = commodity.amount + commodity.commodity_rows.sum(:amount)

      btlparams = {
        created_by: user.kuka,
        modified_by: user.kuka,
        transacted_at: commodity.deactivated_at,
        amount: btl_dep_value * -1,
        description: "Evl käsittely: #{commodity.depreciation_remainder_handling}"
      }
      when 'E'
        raise ArgumentError.new 'Logic not yet implemented'
      else
        raise ArgumentError.new 'Nonexisting depreciation remainder handling type'
      end
      commodity.commodity_rows.create! btlparams
    end

    def date_in_calculation_period?(date)
      (fiscal_start..fiscal_end).cover?(date.try(:to_date))
    end
end
