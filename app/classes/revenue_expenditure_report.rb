class RevenueExpenditureReport
  def initialize(period)
    raise ArgumentError, "pass month as integer" unless period.is_a? Integer

    @date_begin = Date.today.months_ago period
    @date_end = Date.today.months_since period
    @beginning_of_week = Date.today.beginning_of_week
    @end_of_week = Date.today.end_of_week
    @previous_week = Date.today.beginning_of_week.yesterday
    @yesterday = Date.yesterday
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
    Head::SalesInvoice.sent.unpaid.where("erpcm < ?", @beginning_of_week).sum(:summa)
  end

  def overdue_accounts_receivable
    if Date.today != @beginning_of_week
      Head::SalesInvoice.sent.unpaid.where(erpcm: @beginning_of_week..@yesterday)
      .joins(:accounting_rows).where.not(tiliointi: { tilino: Current.company.factoringsaamiset })
      .sum('tiliointi.summa')
    else
      0
    end
  end

  def history_purchaseinvoice
    Head.all_purchase_invoices.unpaid.where("erpcm < ?", @beginning_of_week).sum(:summa)
  end

  def overdue_accounts_payable
    if Date.today != @beginning_of_week
      Head.all_purchase_invoices.unpaid.where(erpcm: @beginning_of_week..@yesterday).sum(:summa)
    else
      0
    end
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
    Head::SalesInvoice.sent.where(erpcm: start..stop)
    .joins(:accounting_rows).where.not(tiliointi: { tilino: Current.company.factoringsaamiset })
    .sum('tiliointi.summa')
  end

  def purchases(start, stop)
    Head.all_purchase_invoices.where(erpcm: start..stop)
    .joins(:accounting_rows).where.not(tiliointi: { tilino: Current.company.factoringsaamiset })
    .sum('tiliointi.summa')
  end
end
