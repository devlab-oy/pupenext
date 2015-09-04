class RevenueExpenditureReport
  def initialize(period)
    raise ArgumentError, "pass month as integer" unless period.is_a? Integer

    @date_end = Date.today.months_since period
    @beginning_of_week = Date.today.beginning_of_week
    @end_of_week = Date.today.end_of_week
    @yesterday = Date.yesterday

    @weekly_sum = {
      sales: BigDecimal(0),
      purchases: BigDecimal(0),
      concern_accounts_receivable: BigDecimal(0),
      concern_accounts_payable: BigDecimal(0),
    }

    @sales = BigDecimal(0)
    @purchases = BigDecimal(0)
  end

  def data
    {
      history_salesinvoice: history_salesinvoice,
      history_purchaseinvoice: history_purchaseinvoice,
      overdue_accounts_payable: overdue_accounts_payable,
      overdue_accounts_receivable: overdue_accounts_receivable,
      weekly: weekly,
      weekly_sum: @weekly_sum,
    }
  end

  private

  def unpaid_sent_sales_invoices
    Head::SalesInvoice.sent.unpaid.joins(:accounting_rows).merge(Head::VoucherRow.without_factoring)
  end

  def sent_factoring_sales_invoices
    Head::SalesInvoice.sent.joins(:accounting_rows).merge(Head::VoucherRow.factoring)
  end

  def sent_sales_invoice_concern_accounts_receivable
    Head::SalesInvoice.sent.joins(:accounting_rows).merge(Head::VoucherRow.concern_accounts_receivable)
  end

  def purchase_invoice_concern_accounts_payable
    Head::PurchaseInvoice.joins(:accounting_rows).merge(Head::VoucherRow.concern_accounts_payable)
  end

  def unpaid_purchase_invoice
    Head::PurchaseInvoice.unpaid.joins(:accounting_rows)
  end

  def sent_sales_invoice_without_factoring_concern
    Head::SalesInvoice.sent
    .joins(:accounting_rows).merge(Head::VoucherRow.without_factoring_concern_accounts_receivable)
  end

  def purchase_invoice_without_concern_accounts_payable
    Head::PurchaseInvoice.joins(:accounting_rows).merge(Head::VoucherRow.without_concern_accounts_payable)
  end

  def history_salesinvoice
    unpaid_sent_sales_invoices.where("erpcm < ?", @beginning_of_week).sum("tiliointi.summa * -1")
  end

  def overdue_accounts_receivable
    overdue_accounts('receivable') * -1
  end

  def overdue_accounts_payable
    overdue_accounts 'payable'
  end

  def which_overdue_account(type)
    type == 'receivable' ? unpaid_sent_sales_invoices : unpaid_purchase_invoice
  end

  def overdue_accounts(type)
    if Date.today != @beginning_of_week
      which_overdue_account(type).where(erpcm: @beginning_of_week..@yesterday).sum("tiliointi.summa")
    else
      BigDecimal(0)
    end
  end

  def concern_accounts_receivable(start, stop)
    sent_sales_invoice_concern_accounts_receivable.where(erpcm: start..stop).sum("tiliointi.summa")
  end

  def overdue_factoring(start, stop)
    if Date.today != @beginning_of_week
      sent_factoring_sales_invoices.where(erpcm: start..stop)
      .sum("(tiliointi.summa * 0.3) * -1")
    else
      BigDecimal(0)
    end
  end

  def current_week_factoring(start, stop)
    sent_factoring_sales_invoices.where(erpcm: start..stop, tapvm: (start+1)..(stop+1))
    .sum("(tiliointi.summa * 0.7) * -1")
  end

  def history_purchaseinvoice
    unpaid_purchase_invoice.where("erpcm < ?", @beginning_of_week).sum('tiliointi.summa')
  end

  def concern_accounts_payable(start, stop)
    purchase_invoice_concern_accounts_payable.where(erpcm: start..stop).sum("tiliointi.summa")
  end

  def sum_sales(start, stop)
    amount  = sales(start, stop)
    amount += overdue_factoring(start, stop)
    amount += current_week_factoring(start, stop)
    amount
  end

  def sum_purchases(start, stop, week)
    amount = purchases(start, stop)
    amount += BigDecimal(alternative_expenditures(week).sum(:selitetark_2))
    amount
  end

  def weekly
    loop_weeks.map do |week|

      @sales = sum_sales(week[:beginning], week[:ending])
      @purchases = sum_purchases(week[:beginning], week[:ending], week[:week])

      @concern_accounts_receivable = concern_accounts_receivable(week[:beginning], week[:ending])
      @concern_accounts_payable = concern_accounts_payable(week[:beginning], week[:ending])

      @weekly_sum[:sales] += @sales
      @weekly_sum[:purchases] += @purchases
      @weekly_sum[:concern_accounts_receivable] += @concern_accounts_receivable
      @weekly_sum[:concern_accounts_payable] += @concern_accounts_payable

      {
        week: week[:week],
        week_sanitized: week[:week].tr(' / ', '_'),
        sales: @sales,
        purchases: @purchases,
        concern_accounts_receivable: @concern_accounts_receivable,
        concern_accounts_payable: @concern_accounts_payable,
        alternative_expenditures: expenditures_for_week(week[:week]),
      }
    end
  end

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

  def sales(start, stop)
    sent_sales_invoice_without_factoring_concern.where(erpcm: start..stop).sum("tiliointi.summa * -1")
  end

  def purchases(start, stop)
    purchase_invoice_without_concern_accounts_payable.where(erpcm: start..stop).sum('tiliointi.summa')
  end

  def alternative_expenditures(week)
    Keyword::RevenueExpenditureReportData.where(selite: week)
  end

  def expenditures_for_week(week)
    alternative_expenditures(week).map { |e| { description: e.selitetark, amount: e.selitetark_2 } }
  end
end
