class RevenueExpenditureReport
  def initialize(period)
    raise ArgumentError, "pass month as integer" unless period.is_a? Integer

    @date_end = Date.today.months_since period
    @beginning_of_week = Date.today.beginning_of_week
    @yesterday = Date.yesterday

    @weekly_sum = {
      sales: BigDecimal(0),
      purchases: BigDecimal(0)
    }

    @weekly_alternative_expenditure = {}
  end

  def data
    {
      history_salesinvoice: history_salesinvoice,
      history_purchaseinvoice: history_purchaseinvoice,
      overdue_accounts_payable: overdue_accounts_payable,
      overdue_accounts_receivable: overdue_accounts_receivable,
      weekly: weekly,
      weekly_sum: @weekly_sum,
      weekly_alternative_expenditure: weekly_alternative_expenditure,
    }
  end

  def self.delete_keyword(params)

    if Keyword::RevenueExpenditureReportData.delete params[:id]
      return true
    else
      return false
    end
  end

  def self.update_keyword(params)

    update_params = {
      selite: params[:week],
      selitetark: params[:name],
      selitetark_2: params[:sum],
    }

    if Keyword::RevenueExpenditureReportData.update params[:id], update_params
      return true
    else
      return false
    end
  end

  def self.save_keyword(params)

    save_params = {
      selite: params[:week],
      selitetark: params[:name],
      selitetark_2: params[:sum],
    }

    keyword = Keyword::RevenueExpenditureReportData.new save_params

    if keyword.save
      return true
    else
      return false
    end
  end

  private

  def history_salesinvoice
    Head::SalesInvoice.sent.unpaid.where("erpcm < ?", @beginning_of_week)
    .joins(:accounting_rows).where.not(tiliointi: { tilino: Current.company.factoringsaamiset })
    .sum("tiliointi.summa * -1")
  end

  def overdue_accounts_receivable
    if Date.today != @beginning_of_week
      Head::SalesInvoice.sent.unpaid.where(erpcm: @beginning_of_week..@yesterday)
      .joins(:accounting_rows).where.not(tiliointi: { tilino: Current.company.factoringsaamiset })
      .sum("tiliointi.summa * -1")
    else
      BigDecimal(0)
    end
  end

  def overdue_factoring(start, stop)
    if Date.today != @beginning_of_week
      Head::SalesInvoice.sent.where(erpcm: start..stop)
      .joins(:accounting_rows).where(tiliointi: { tilino: Current.company.factoringsaamiset })
      .sum("(tiliointi.summa * 0.3) * -1")
    else
      BigDecimal(0)
    end
  end

  def current_week_factoring(start, stop)
    Head::SalesInvoice.sent.where(erpcm: start..stop, tapvm: (start+1)..(stop+1))
    .joins(:accounting_rows).where(tiliointi: { tilino: Current.company.factoringsaamiset })
    .sum("(tiliointi.summa * 0.7) * -1")
  end

  def history_purchaseinvoice
    Head.all_purchase_invoices.unpaid.where("erpcm < ?", @beginning_of_week)
    .joins(:accounting_rows).sum('tiliointi.summa')
  end

  def overdue_accounts_payable
    if Date.today != @beginning_of_week
      Head.all_purchase_invoices.unpaid.where(erpcm: @beginning_of_week..@yesterday)
      .joins(:accounting_rows).sum('tiliointi.summa')
    else
      BigDecimal(0)
    end
  end

  def weekly
    loop_weeks.map do |week|

      @sales  = sales(week[:beginning], week[:ending])
      @sales += overdue_factoring(week[:beginning], week[:ending])
      @sales += current_week_factoring(week[:beginning], week[:ending])

      @purchases = purchases(week[:beginning], week[:ending])

      @weekly_sum[:sales] += @sales
      @weekly_sum[:purchases] += @purchases

      {
        week: week[:week],
        week_sanitized: week[:week].tr(' / ', '_'),
        sales: @sales,
        purchases: @purchases
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
    .sum("tiliointi.summa * -1")
  end

  def purchases(start, stop)
    Head.all_purchase_invoices.where(erpcm: start..stop)
    .joins(:accounting_rows).sum('tiliointi.summa')
  end

  def keywords(week)
    Keyword::RevenueExpenditureReportData.where(selite: week)
  end

  def weekly_alternative_expenditure
    loop_weeks.each do |week|
      if @weekly_alternative_expenditure[week[:week]].nil?
        @weekly_alternative_expenditure[week[:week]] = []
      end

      keywords(week[:week]).each do |k|
        @weekly_alternative_expenditure[week[:week]] << k
        @weekly_sum[:purchases] += BigDecimal(k.selitetark_2)
      end
    end
    @weekly_alternative_expenditure.reject { |_, v| v.empty? }
  end
end
