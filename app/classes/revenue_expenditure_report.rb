class RevenueExpenditureReport
  def initialize(period)
    raise ArgumentError, "pass month as integer" unless period.is_a? Integer

    @date_begin = Date.today.months_ago period
    @date_end = Date.today.months_since period
    @beginning_of_week = Date.today.beginning_of_week
    @end_of_week = Date.today.end_of_week
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
    Head::SalesInvoice.sent.unpaid
      .where(erpcm: @date_begin..@previous_week)
      .sum(:summa)
  end

  def overdue_accounts_receivable
    Head::SalesInvoice.sent.unpaid
      .where(erpcm: @beginning_of_week..@end_of_week)
      .sum(:summa)
  end

  def history_purchaseinvoice
    Head.all_purchase_invoices.unpaid
      .where(erpcm: @date_begin..@previous_week)
      .sum(:summa)
  end

  def overdue_accounts_payable
    Head.all_purchase_invoices.unpaid
      .where(erpcm: @beginning_of_week..@end_of_week)
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
    Head::SalesInvoice.where(alatila: :X).paid
      .where(erpcm: start..stop)
      .sum(:summa)
  end

  def purchases(start, stop)
    Head.all_purchase_invoices.paid
      .where(erpcm: start..stop)
      .sum(:summa)
  end
end
