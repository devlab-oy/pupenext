module Administration::RevenueExpenditureReportDatumHelper
  def week_options(week_year)

    if week_year.empty?
      week_year = "#{Date.parse(Time.now.to_s).cweek} / #{Date.parse(Time.now.to_s).cwyear}"
    end

    week, year = week_year.to_s.split(' / ')
    week = week.to_i
    year = year.to_i

    date_from = Date.commercial(year, week).years_ago(1)
    date_to = Date.commercial(year, week).years_since(1)

    options = date_from.upto(date_to).map do |d|
      d = "#{d.cweek} / #{d.cwyear}"
      [ d, d ]
    end

    options.uniq!
  end
end
