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
      history_salesinvoice: history_salesinvoice,
      history_purchaseinvoice: history_purchaseinvoice,
      overdue_accounts_payable: overdue_accounts_payable,
      overdue_accounts_receivable: overdue_accounts_receivable,
      weekly: weekly,
      weekly_sum: weekly_summary,
    }
  end

  private

    def company
      @current_company ||= Current.company
    end

    # fetches sent unpaid sales invoices
    # join accounting rows, because amounts are calculated from voucher rows
    # exclude rows with company's factoring accounts receivable account number
    def unpaid_sent_sales_invoices
      company.sales_invoices.sent.unpaid.joins(:accounting_rows)
        .where.not(tiliointi: { tilino: company.factoringsaamiset })
    end

    # fetch sent paid/unpaid sales invoices
    # join accounting rows, because amounts are calculated from voucher rows
    # include only rows with company's factoring accounts receivable account number
    def sent_factoring_sales_invoices
      company.sales_invoices.sent.joins(:accounting_rows)
        .where(tiliointi: { tilino: company.factoringsaamiset })
    end

    # fetch sent sales invoices
    # join accounting rows, because amounts are calculated from voucher rows
    # include only rows with company's concern accounts receivable account number
    def sent_sales_invoice_concern_accounts_receivable
      company.sales_invoices.sent.joins(:accounting_rows)
        .where(tiliointi: { tilino: company.konsernimyyntisaamiset })
    end

    # fetch all purchace invoices
    # join accounting rows, because amounts are calculated from voucher rows
    # include only rows with company accounts payable accounting rows
    def purchase_invoice_concern_accounts_payable
      company.heads.purchase_invoices.joins(:accounting_rows)
        .where(tiliointi: { tilino: company.konserniostovelat })
    end

    # fetch all unpaid purchase invoices
    # join accounting rows, because amounts are calculated from voucher rows
    def unpaid_purchase_invoice
      company.heads.purchase_invoices.unpaid.joins(:accounting_rows)
    end

    # fetch all sent sales invoices
    # join accounting rows, because amounts are calculated from voucher rows
    # exclude all rows with factoring and company accounts receivable account numbers
    def sent_sales_invoice_without_factoring_concern
      company.sales_invoices.sent.joins(:accounting_rows)
        .where.not(tiliointi: { tilino: [company.factoringsaamiset, company.konsernimyyntisaamiset] })
    end

    # fetch all purchase invoices
    # join accounting rows, because amounts are calculated from voucher rows
    # exclude rows with company accounts payable account number
    def purchase_invoice_without_concern_accounts_payable
      company.heads.purchase_invoices.joins(:accounting_rows)
        .where.not(tiliointi: { tilino: company.konserniostovelat })
    end

    # @return [BigDecimal] sum of invoices
    #
    # overdue date must be older than current week
    # fetch sum from accounting rows, because it can be partially paid
    # accounting rows sum is negative, so it must be converted to positive number
    def history_salesinvoice
      unpaid_sent_sales_invoices.where("erpcm < ?", @beginning_of_week).sum("tiliointi.summa * -1")
    end

    # @return (see #overdue_accounts)
    # @return returned sum from #overdue_accounts is negative, so it must be converted to positive number
    def overdue_accounts_receivable
      overdue_accounts('receivable') * -1
    end

    # @return (see #overdue_accounts)
    def overdue_accounts_payable
      overdue_accounts 'payable'
    end

    # @param type [String] values 'receivable' or 'payable'
    # @return [BigDecimal] sum of invoices
    #
    # if current date is the beginning of week return 0, because invoice cannot be overdue
    # if current date is in the middle of week, or in the end, calculate sum from accounting rows
    # @example current date is thu, overdue date range is mon - wed
    def overdue_accounts(type)
      return 0.0 unless Date.today != @beginning_of_week

      unpaid = type == 'receivable' ? unpaid_sent_sales_invoices : unpaid_purchase_invoice
      unpaid.where(erpcm: @beginning_of_week..@yesterday).sum("tiliointi.summa")
    end

    # @param start [Date] starting date
    # @param stop [Date] ending date
    # @return [BigDecimal] accounting rows sum of sent sales invoices and company accounts receivables within date range
    def concern_accounts_receivable(start, stop)
      sent_sales_invoice_concern_accounts_receivable.where(erpcm: start..stop).sum("tiliointi.summa")
    end

    # @param (see #sum_sales)
    # @return [BigDecimal] sum of invoices in the date range
    #
    # if current date is the beginning of week return 0, because invoice cannot be overdue
    # if current date is in the middle of week, or in the end, calculate sum from accounting rows
    # only 30% of sum is calculated for overdues
    # the rest 70% is calculated in (see #current_week_factoring)
    # sales invoice's accounting rows sum is negative, so it must be converted to positive number for view
    def overdue_factoring(start, stop)
      if Date.today != @beginning_of_week
        sent_factoring_sales_invoices.where(erpcm: start..stop).where("lasku.tapvm < ?", @beginning_of_week)
        .sum("(tiliointi.summa * 0.3) * -1")
      else
        BigDecimal(0)
      end
    end

    # @param (see #sum_sales)
    # @return [BigDecimal] 70% of sent factoring sales invoices' sum
    #
    # return only 70% of sum
    # the rest 30% is calculated in (see #overdue_factoring)
    # overdue date has to be within date range
    # event date has to be within date range plus one day added for both ends
    # sales invoice's accounting rows sum is negative, so it must be converted to positive number for view
    # @example if event day is wednedsay, 70% is calculated for thursday
    def current_week_factoring(start, stop)
      sent_factoring_sales_invoices.where(erpcm: start..stop, tapvm: (start+1)..(stop+1))
      .sum("(tiliointi.summa * 0.7) * -1")
    end

    # @return (see #unpaid_purchase_invoice)
    #
    # overdue date must be older than current week
    # fetch sum from accounting rows, because it can be partially paid
    def history_purchaseinvoice
      unpaid_purchase_invoice.where("erpcm < ?", @beginning_of_week).sum('tiliointi.summa')
    end

    # @param start [Date] starting date
    # @param stop [Date] ending date
    # @return [BigDecimal] sum of purchase invoices which had company accounts payable account rows
    def concern_accounts_payable(start, stop)
      purchase_invoice_concern_accounts_payable.where(erpcm: start..stop).sum("tiliointi.summa")
    end

    # @param start [Date] starting date
    # @param stop [Date] ending date
    # @return [BigDecimal] amount of date range's sales invoices and factoring invoices (overdued and not overdued)
    def sum_sales(start, stop)
      amount  = sales(start, stop)
      amount += overdue_factoring(start, stop)
      amount += current_week_factoring(start, stop)
      amount
    end

    # @param start [Date] starting date
    # @param stop [Date] ending date
    # @param week [String] week / year combo, example '35 / 2015'
    # @return [BigDecimal] amount of date range's purchase invoices and alternative expenditure's
    def sum_purchases(start, stop, week)
      amount = purchases(start, stop)
      amount += BigDecimal(alternative_expenditures(week).sum(:selitetark_2))
      amount
    end

    # @return [Hash] sum of all weekly sales invoices, purchase invoices, company accounts receivables and company accounts payables
    def weekly_summary
      @weekly_sum = {
        sales: BigDecimal(0),
        purchases: BigDecimal(0),
        concern_accounts_receivable: BigDecimal(0),
        concern_accounts_payable: BigDecimal(0),
      }

      weekly.each do |w|
        @weekly_sum[:sales] += w[:sales]
        @weekly_sum[:purchases] += w[:purchases]
        @weekly_sum[:concern_accounts_receivable] += w[:concern_accounts_receivable]
        @weekly_sum[:concern_accounts_payable] += w[:concern_accounts_payable]
      end

      @weekly_sum
    end

    # @return [Array] contains weekly hashes of
    #  week/year combo (see #loop_weeks)
    #  looped week's sales sum (see #sum_sales)
    #  looped week's purchases sum (see #sum_purchases)
    #  looped week's company accounts receivable sum (see #concern_accounts_receivable)
    #  looped week's company accounts payable sum (see #concern_accounts_payable)
    #  looped week's alternative expenditures (see #expenditures_for_week)
    def weekly
      loop_weeks.map do |week|
        {
          week: week[:week],
          week_sanitized: week[:week].tr(' / ', '_'),
          sales: sum_sales(week[:beginning], week[:ending]),
          purchases: sum_purchases(week[:beginning], week[:ending], week[:week]),
          concern_accounts_receivable: concern_accounts_receivable(week[:beginning], week[:ending]),
          concern_accounts_payable: concern_accounts_payable(week[:beginning], week[:ending]),
          alternative_expenditures: expenditures_for_week(week[:week]),
        }
      end
    end

    # @return [Array] unique week/year grouping with week's beginning and ending dates
    def loop_weeks
      weeks = []
      @beginning_of_week.upto(@date_end) do |date|
        weeks << {
          week: "#{date.cweek} / #{date.cwyear}",
          beginning: date.beginning_of_week,
          ending: date.end_of_week
        }
      end
      weeks.uniq!
    end

    # @param (see #sum_sales)
    # @note (see #sent_sales_invoice_without_factoring_concern)
    # @return [BigDecimal] sum from accounting rows
    def sales(start, stop)
      sent_sales_invoice_without_factoring_concern.where(erpcm: start..stop).sum("tiliointi.summa * -1")
    end

    # @param start [Date] starting date
    # @param stop [Date] ending date
    # @note (see #purchase_invoice_without_concern_accounts_payable)
    # @return [BigDecimal] sum from accounting rows
    def purchases(start, stop)
      purchase_invoice_without_concern_accounts_payable.where(erpcm: start..stop).sum('tiliointi.summa')
    end

    # @param (see #expenditures_for_week)
    # @return [ActiveRecord::Relation] alternative expenditures
    def alternative_expenditures(week)
      Keyword::RevenueExpenditureReportData.where(selite: week)
    end

    # @note alternative expenditures are user's own custom expenditures which are stored in keywords
    # @note (see #alternative_expenditures)
    # @param week [String] week & year combination
    # @example '35 / 2015'
    # @return [Array] alternative expenditures
    # @example [ description: 'Foo', amount: '100' ]
    def expenditures_for_week(week)
      alternative_expenditures(week).map { |e| { description: e.selitetark, amount: e.selitetark_2 } }
    end
end
