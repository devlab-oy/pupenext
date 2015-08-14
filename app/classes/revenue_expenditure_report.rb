class RevenueExpenditureReport
  def initialize(period)
    raise ArgumentError, "pass month as integer" unless period.is_a? Integer

    @date_begin = Date.today.months_ago period
    @date_end = Date.today.months_since period
    @beginning_of_week = Date.today.beginning_of_week
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
    Head::SalesInvoice.where(alatila: :X)
      .where(erpcm: @date_begin..@beginning_of_week)
      .where(tapvm: @date_begin..@beginning_of_week)
      .where.not(mapvm: '0000-00-00').sum(:summa)
  end

  def overdue_accounts_receivable
    Head::SalesInvoice.where(alatila: :X)
      .where(erpcm: @date_begin..@beginning_of_week)
      .where(tapvm: @date_begin..@beginning_of_week)
      .where(mapvm: '0000-00-00').sum(:summa)
  end

  def history_purchaseinvoice
    statues = Head::PurchaseInvoice::INVOICE_TYPES

    Head.where(tila: statues)
      .where(erpcm: @date_begin..@beginning_of_week)
      .where(tapvm: @date_begin..@beginning_of_week)
      .where.not(mapvm: '0000-00-00').sum(:summa)
  end

  def overdue_accounts_payable
    statues = Head::PurchaseInvoice::INVOICE_TYPES

    Head.where(tila: statues)
      .where(erpcm: @date_begin..@beginning_of_week)
      .where(tapvm: @date_begin..@beginning_of_week)
      .where(mapvm: '0000-00-00').sum(:summa)
  end

  def weekly
    weeks = []
    loop_weeks.map do |week_year|
      week, year = week_year.split(' / ')
      week = week.to_i
      year = year.to_i
      weeks << {
        week: week_year,
        sales: sales(Date.commercial(year, week, 1), Date.commercial(year, week, 7)),
        purchases: purchases(Date.commercial(year, week, 1), Date.commercial(year, week, 7))
      }
    end
    weeks
  end

  def loop_weeks
    weeks = []
    @beginning_of_week.upto(@date_end) do |date|
      weeks << "#{date.cweek} / #{date.cwyear}"
    end
    weeks.uniq
  end

  def sales(start, stop)
    Head::SalesInvoice.where(alatila: :X)
      .where(erpcm: start..stop)
      .where(tapvm: @date_begin..stop)
      .sum(:summa)
  end

  def purchases(start, stop)
    statues = Head::PurchaseInvoice::INVOICE_TYPES

    Head.where(tila: statues)
      .where(erpcm: start..stop)
      .where(tapvm: @date_begin..stop)
      .sum(:summa)
  end
end
