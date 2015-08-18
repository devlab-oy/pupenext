class RevenueExpenditureReport
  def initialize(period)
    raise ArgumentError, "pass month as integer" unless period.is_a? Integer

    @date_begin = Date.today.months_ago period
    @date_end = Date.today.months_since period
    @beginning_of_week = Date.today.beginning_of_week
    @previous_week = Date.today.beginning_of_week.yesterday
  end

  def data
    {
      history_salesinvoice: history_salesinvoice,
      history_purchaseinvoice: history_purchaseinvoice,
      overdue_accounts_payable: overdue_accounts_payable,
      overdue_accounts_receivable: overdue_accounts_receivable,
      weekly: weekly
    }
  end

  private

  def history_salesinvoice
    Head::SalesInvoice.sent.paid
      .where(erpcm: @date_begin..@previous_week)
      .where(tapvm: @date_begin..@previous_week)
      .sum(:summa)
  end

  def overdue_accounts_receivable
    Head::SalesInvoice.sent.unpaid
      .where(erpcm: @date_begin..@beginning_of_week)
      .where(tapvm: @date_begin..@beginning_of_week)
      .sum(:summa)
  end

  def history_purchaseinvoice
    Head::PurchaseInvoice.all_purchase_invoices.paid
      .where(erpcm: @date_begin..@previous_week)
      .where(tapvm: @date_begin..@previous_week)
      .sum(:summa)
  end

  def overdue_accounts_payable
    Head::PurchaseInvoice.all_purchase_invoices.unpaid
      .where(erpcm: @date_begin..@beginning_of_week)
      .where(tapvm: @date_begin..@beginning_of_week)
      .sum(:summa)
  end

  def weekly
    loop_weeks.map do |week|
      {
        week: week[:week],
        sales: sales(week[:beginning], week[:ending]),
        purchases: purchases(week[:beginning], week[:ending])
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
    Head::SalesInvoice.where(alatila: :X)
      .where(erpcm: start..stop)
      .where(tapvm: @date_begin..stop)
      .sum(:summa)
  end

  def purchases(start, stop)
    Head::PurchaseInvoice.all_purchase_invoices
      .where(erpcm: start..stop)
      .where(tapvm: @date_begin..stop)
      .sum(:summa)
  end
end
