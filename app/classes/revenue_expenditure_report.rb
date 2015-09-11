class RevenueExpenditureReport
  # @param period [Integer] how many months in the future report calculates weekly sums, example: 1, 2, 3, 6 or 12
  def initialize(period)
    raise ArgumentError, "pass month as integer" unless period.is_a? Integer

    @date_end = Date.today.beginning_of_week.months_since period
    @beginning_of_time = Time.at(0).to_date
    @beginning_of_week = Date.today.beginning_of_week
    @end_of_week = Date.today.end_of_week
    @yesterday = Date.yesterday
  end

  def data
    {
      history_revenue: myyntisaamiset(@beginning_of_time, @beginning_of_week),
      history_expenditure: ostovelat(@beginning_of_time, @beginning_of_week),
      overdue_accounts_payable: myyntisaamiset(@beginning_of_week, @yesterday),
      overdue_accounts_receivable: ostovelat(@beginning_of_week, @yesterday),
      weekly: weekly,
      weekly_sum: weekly_sum,
    }
  end

  private

    def company
      @current_company ||= Current.company
    end

    def myyntisaamiset(start, stop)
      company.sales_invoices.sent.unpaid.joins(:accounting_rows)
        .where(tiliointi: { tilino: company.myyntisaamiset })
        .where(erpcm: start..stop)
        .sum("tiliointi.summa * -1")
    end

    def factoring_myyntisaamiset(start, stop)
      company.sales_invoices.sent.unpaid.joins(:accounting_rows)
        .where(tiliointi: { tilino: company.factoringsaamiset })
        .where(erpcm: start..stop)
        .sum("tiliointi.summa * -1")
    end

    def factoring_myyntisaamiset_tapvm(start, stop)
      company.sales_invoices.sent.unpaid.joins(:accounting_rows)
        .where(tiliointi: { tilino: company.factoringsaamiset })
        .where(tapvm: start..stop)
        .sum("tiliointi.summa * -1")
    end

    def konserni_myyntisaamiset(start, stop)
      company.sales_invoices.sent.unpaid.joins(:accounting_rows)
        .where(tiliointi: { tilino: company.konsernimyyntisaamiset })
        .where(erpcm: start..stop)
        .sum("tiliointi.summa * -1")
    end

    def ostovelat(start, stop)
      company.heads.purchase_invoices.unpaid.joins(:accounting_rows)
        .where(tiliointi: { tilino: company.ostovelat })
        .where(erpcm: start..stop)
        .sum('tiliointi.summa')
    end

    def konserni_ostovelat(start, stop)
      company.heads.purchase_invoices.unpaid.joins(:accounting_rows)
        .where(tiliointi: { tilino: company.konserniostovelat })
        .where(erpcm: start..stop)
        .sum('tiliointi.summa')
    end

    def revenue_expenditures(week)
      company.revenue_expenditures.where(selite: week).sum(:selitetark_2).to_d
    end

    def revenue_expenditures_details(week)
      company.revenue_expenditures.where(selite: week).map do |e|
        {
          description: e.selitetark,
          amount: e.selitetark_2.to_d,
        }
      end
    end

    #  calculate weekly amounts for
    #  - sales
    #  - purchases
    #  - company accounts receivable
    #  - company accounts payable
    #  - alternative expenditures
    def weekly
      @weekly ||= loop_weeks.map do |number, start, stop|

        # Myyntisaamiset menee myyntiin sellaisenaan.
        # Factoring myynnistä 70% kuuluu laittaa viikolle tapahtumapäivän (+ 1pv) mukaan
        # ja loput 30% eräpäivän mukaan.
        sales  = myyntisaamiset(start, stop)
        sales += factoring_myyntisaamiset(start, stop) * 0.3
        sales += factoring_myyntisaamiset_tapvm(start - 1, stop - 1) * 0.7

        # Ostovelat sellaisenaan
        # Mukaan lisätään extrakulut, jota voi syöttää oman käyttöliittymän kautta viikkotasolla
        purchases  = ostovelat(start, stop)
        purchases += revenue_expenditures(number)

       {
          week: number,
          sales: sales,
          purchases: ostovelat(start, stop),
          concern_accounts_receivable: konserni_myyntisaamiset(start, stop),
          concern_accounts_payable: konserni_ostovelat(start, stop),
          alternative_expenditures: revenue_expenditures_details(number),
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
