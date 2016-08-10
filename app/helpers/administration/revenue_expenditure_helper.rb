module Administration::RevenueExpenditureHelper
  def week_options(week_year)
    date_from = parse_date(week_year).years_ago(1)
    date_to   = parse_date(week_year).years_since(1)

    date_from.upto(date_to).map do |d|
      week = Week.new(d)

      [week.human, week.compact]
    end.uniq
  end

  private

    def parse_date(week_year)
      week = week_year[4..5].to_i
      year = week_year[0..3].to_i

      Date.commercial year, week
    end
end
