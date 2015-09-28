module Administration::RevenueExpenditureReportDatumHelper
  def week_options(week_year)

    if week_year.empty?
      week_year = "#{Date.parse(Time.now.to_s).cweek} / #{Date.parse(Time.now.to_s).cwyear}"
    end

    date_from, date_to = date_range week_year

    options = date_from.upto(date_to).map do |d|
      d = "#{d.cweek} / #{d.cwyear}"
      [ d, d ]
    end

    options.uniq!
  end

  def sanitize_week_year(week_year)
    week, year = week_year.to_s.split(' / ')
    return week.to_i, year.to_i
  end

  def date_range(week_year)
    week, year = sanitize_week_year week_year
    return Date.commercial(year, week).years_ago(1), Date.commercial(year, week).years_since(1)
  end
end
