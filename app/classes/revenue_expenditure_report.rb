class RevenueExpenditureReport
  # @param period [Integer] how many months in the future report calculates weekly sums, example: 1, 2, 3, 6 or 12
  def initialize(period)
    raise ArgumentError, "pass month as integer" unless period.is_a? Integer

    @date_end = Date.today.beginning_of_week.months_since period
    @beginning_of_week = Date.today.beginning_of_week
    @end_of_week = Date.today.end_of_week
    @yesterday = Date.yesterday
  end

  def data
    {
      history_revenue: history_salesinvoice,
      history_expenditure: history_purchaseinvoice,
      overdue_accounts_payable: overdue_accounts_payable,
      overdue_accounts_receivable: overdue_accounts_receivable,
      weekly: weekly,
      weekly_sum: weekly_sum,
    }
  end

  private

    def company
      @current_company ||= Current.company
    end

    # fetch total amount of unpaid sales invoices that have expired
    # fetch sum from accounting rows, because invoices can be partially paid
    # exclude factoringsaamiset
    def history_salesinvoice
      company.sales_invoices.sent.unpaid.joins(:accounting_rows)
        .where.not(tiliointi: { tilino: company.factoringsaamiset })
        .where("erpcm < ?", @beginning_of_week)
        .sum("tiliointi.summa * -1")
    end

    # fetch total amount of unpaid purchase invoices that are overdue
    # fetch sum from accounting rows, because invoices can be partially paid
    def history_purchaseinvoice
      company.heads.purchase_invoices.unpaid.joins(:accounting_rows)
        .where("erpcm < ?", @beginning_of_week)
        .sum('tiliointi.summa')
    end

    # fetch total amount of sent and unpaid sales invoices that are due this week
    # fetch sum from accounting rows, because invoices can be partially paid
    def overdue_accounts_receivable
      company.sales_invoices.sent.unpaid.joins(:accounting_rows)
        .where.not(tiliointi: { tilino: company.factoringsaamiset })
        .where(erpcm: @beginning_of_week..@yesterday)
        .sum("tiliointi.summa") * -1
    end

    # fetch total amount of unpaid purchase invoices that are due this week
    # fetch sum from accounting rows, because invoices can be partially paid
    def overdue_accounts_payable
      company.heads.purchase_invoices.unpaid.joins(:accounting_rows)
        .where(erpcm: @beginning_of_week..@yesterday)
        .sum("tiliointi.summa")
    end

    #  calculate weekly amounts for
    #  - sales
    #  - purchases
    #  - company accounts receivable
    #  - company accounts payable
    #  - alternative expenditures
    def weekly
      @weekly ||= loop_weeks.map do |number, start, stop|
        {
          week: number,
          sales: sum_sales(start, stop),
          purchases: sum_purchases(start, stop, number),
          concern_accounts_receivable: concern_accounts_receivable(start, stop),
          concern_accounts_payable: concern_accounts_payable(start, stop),
          alternative_expenditures: alternative_expenditures(number),
        }
      end
    end

    # return total weekly sales, purchases, and company accounts receivables/payables
    def weekly_sum
      {
        sales: weekly.map { |w| w[:sales] }.sum,
        purchases: weekly.map { |w| w[:sales] }.sum,
        concern_accounts_receivable: weekly.map { |w| w[:concern_accounts_receivable] }.sum,
        concern_accounts_payable: weekly.map { |w| w[:concern_accounts_payable] }.sum,
      }
    end

    # fetch sent sales invoices
    # join accounting rows, because amounts are calculated from voucher rows
    # include only rows with company's concern accounts receivable account number
    def sent_sales_invoice_concern_accounts_receivable
      company.sales_invoices.sent.joins(:accounting_rows)
        .where(tiliointi: { tilino: company.konsernimyyntisaamiset })
    end

    def concern_accounts_receivable(start, stop)
      sent_sales_invoice_concern_accounts_receivable
        .where(erpcm: start..stop)
        .sum("tiliointi.summa")
    end

    # return purchase invoices sum within company group
    def concern_accounts_payable(start, stop)
      company.heads.purchase_invoices.joins(:accounting_rows)
        .where(tiliointi: { tilino: company.konserniostovelat })
        .where(erpcm: start..stop)
        .sum("tiliointi.summa")
    end

    # return total sales invoices and factoring invoices (overdued and not overdued)
    def sum_sales(start, stop)
      return 0.0 if start > stop

      amount  = sales(start, stop)
      amount += overdue_factoring(start, stop)
      amount += current_week_factoring(start, stop)
      amount
    end

    # return total amount of sent sales invoices excluding factoring- and konsernimyyntisaamiset
    def sales(start, stop)
      company.sales_invoices.sent.joins(:accounting_rows)
        .where.not(tiliointi: { tilino: [company.factoringsaamiset, company.konsernimyyntisaamiset] })
        .where(erpcm: start..stop)
        .sum("tiliointi.summa * -1")
    end

    # return sum of sent sales invoices in the date range including only factoringsaamiset
    # only 30% of sum is calculated for overdues
    # the rest 70% is calculated in #current_week_factoring
    # sales invoice's accounting rows are negative, so convert them to positive
    def overdue_factoring(start, stop)
      company.sales_invoices.sent.joins(:accounting_rows)
        .where(tiliointi: { tilino: company.factoringsaamiset })
        .where(erpcm: start..stop)
        .where("lasku.tapvm < ?", @beginning_of_week)
        .sum("tiliointi.summa * 0.3 * -1")
    end

    # return sum of sent sales invoices in the date range including only factoringsaamiset
    # return only 70% of sum
    # the rest 30% is calculated in #overdue_factoring
    # overdue date has to be within date range
    # event date has to be within date range plus one day added for both ends
    # sales invoice's accounting rows are negative, so convert them to positive
    def current_week_factoring(start, stop)
      company.sales_invoices.sent.joins(:accounting_rows)
        .where(tiliointi: { tilino: company.factoringsaamiset })
        .where(erpcm: start..stop, tapvm: (start + 1)..(stop + 1))
        .sum("tiliointi.summa * 0.7 * -1")
    end

    # return purchase invoices total excluding konserniostovelat
    def sum_purchases(start, stop, week)
      amount = company.heads.purchase_invoices.joins(:accounting_rows)
                .where.not(tiliointi: { tilino: company.konserniostovelat })
                .where(erpcm: start..stop)
                .sum('tiliointi.summa')

      amount += expenditures_for_week(week).sum(:selitetark_2).to_d
      amount
    end

    # alternative expenditures are user's own custom expenditures which are stored in keywords per week
    def expenditures_for_week(week)
      Keyword::RevenueExpenditureReportData.where(selite: week)
    end

    def alternative_expenditures(week)
      expenditures_for_week(week).map do |e|
        {
          description: e.selitetark,
          amount: e.selitetark_2.to_d,
        }
      end
    end

    # return week numbers and start/end dates for weeks in the requested perioid
    def loop_weeks
      @beginning_of_week.upto(@date_end).map do |date|
        [
          "#{date.cweek} / #{date.cwyear}",
          date.beginning_of_week,
          date.end_of_week
        ]
      end.uniq
    end
end
