class Reports::RevenueExpenditure
  # @param period [Integer] how many months in the future report calculates weekly sums, example: 1, 2, 3, 6 or 12
  def initialize(period)
    raise ArgumentError, "pass month as integer" unless period.is_a? Integer

    @period = period
  end

  def data
    time_start = Time.at(0).to_date
    yesterday  = Date.today - 1.day

    {
      history_revenue: myyntisaamiset(time_start, yesterday) + factoring_myyntisaamiset_sum(time_start, yesterday),
      history_expenditure: ostovelat(time_start, yesterday) + history_revenue_expenditures_details,
      history_concern_accounts_payable: konserni_ostovelat(time_start, yesterday),
      history_concern_accounts_receivable: konserni_myyntisaamiset(time_start, yesterday),
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
        .sum("tiliointi.summa")
    end

    def factoring_myyntisaamiset_sum(start, stop)
      sum = factoring_myyntisaamiset(start, stop) * 0.3
      sum += factoring_myyntisaamiset_tapvm(start - 1, stop - 1) * 0.7
      sum
    end

    def factoring_myyntisaamiset(start, stop)
      company.sales_invoices.sent.unpaid.joins(:accounting_rows)
        .where(tiliointi: { tilino: company.factoringsaamiset })
        .where(erpcm: start..stop)
        .sum("tiliointi.summa")
    end

    def factoring_myyntisaamiset_tapvm(start, stop)
      company.sales_invoices.sent.unpaid.joins(:accounting_rows)
        .where(tiliointi: { tilino: company.factoringsaamiset })
        .where(tapvm: start..stop)
        .sum("tiliointi.summa")
    end

    def konserni_myyntisaamiset(start, stop)
      company.sales_invoices.sent.unpaid.joins(:accounting_rows)
        .where(tiliointi: { tilino: company.konsernimyyntisaamiset })
        .where(erpcm: start..stop)
        .sum("tiliointi.summa")
    end

    def ostovelat(start, stop)
      company.heads.purchase_invoices.unpaid.joins(:accounting_rows)
        .where(tiliointi: { tilino: company.ostovelat })
        .where(erpcm: start..stop)
        .sum('tiliointi.summa * -1')
    end

    def konserni_ostovelat(start, stop)
      company.heads.purchase_invoices.unpaid.joins(:accounting_rows)
        .where(tiliointi: { tilino: company.konserniostovelat })
        .where(erpcm: start..stop)
        .sum('tiliointi.summa * -1')
    end

    def revenue_expenditures(week)
      company.revenue_expenditures
        .where(selite: week)
        .sum(:selitetark_2).to_d
    end

    def revenue_expenditures_details(week)
      company.revenue_expenditures.where(selite: week).map do |e|
        {
          description: e.selitetark,
          amount: e.selitetark_2.to_d,
        }
      end
    end

    def history_revenue_expenditures_details
      year_week = Date.today.strftime "%Y%V"
      company.revenue_expenditures.where("selite < ?", year_week).pluck(:selitetark_2).map(&:to_d).sum
    end

    #  calculate weekly amounts for
    #  - sales
    #  - purchases
    #  - company accounts receivable
    #  - company accounts payable
    #  - alternative expenditures
    def weekly
      @weekly ||= loop_weeks.map do |number, year_week, start, stop|

        # Myyntisaamiset menee myyntiin sellaisenaan.
        # Factoring myynnistä 70% kuuluu laittaa viikolle tapahtumapäivän (+ 1pv) mukaan
        # ja loput 30% eräpäivän mukaan.
        sales  = myyntisaamiset(start, stop)
        sales += factoring_myyntisaamiset_sum(start, stop)

        # Ostovelat sellaisenaan
        # Mukaan lisätään extrakulut, jota voi syöttää oman käyttöliittymän kautta viikkotasolla
        purchases  = ostovelat(start, stop)
        purchases += revenue_expenditures(year_week)

        {
          week: number,
          sales: sales,
          purchases: purchases,
          concern_accounts_receivable: konserni_myyntisaamiset(start, stop),
          concern_accounts_payable: konserni_ostovelat(start, stop),
          alternative_expenditures: revenue_expenditures_details(year_week),
        }
      end
    end

    # return total weekly sales, purchases, and company accounts receivables/payables
    def weekly_sum
      {
        sales: weekly.map { |w| w[:sales] }.sum,
        purchases: weekly.map { |w| w[:purchases] }.sum,
        concern_accounts_receivable: weekly.map { |w| w[:concern_accounts_receivable] }.sum,
        concern_accounts_payable: weekly.map { |w| w[:concern_accounts_payable] }.sum,
      }
    end

    # return week numbers and start/end dates for weeks in the requested perioid
    def loop_weeks
      date_start = Date.today.beginning_of_week
      date_end = date_start + @period.months

      date_start.upto(date_end).map do |date|
        beginning_of_week = date.beginning_of_week
        beginning_of_week = Date.today if beginning_of_week == date_start

        [
          "#{date.cweek} / #{date.cwyear}",
          date.strftime("%Y%V"),
          beginning_of_week,
          date.end_of_week
        ]
      end.uniq
    end
end
