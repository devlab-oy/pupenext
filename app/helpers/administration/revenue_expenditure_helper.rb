module Administration::RevenueExpenditureHelper
  def week_options(week_year)

    if week_year.empty?
      week_year = Date.today.strftime "%Y%V"
    end

    date_from, date_to = date_range week_year

    options = date_from.upto(date_to).map do |d|
      value = d.strftime "%Y%V"
      text = d.strftime "%W / %Y"
      [ text, value ]
    end

    options.uniq!
  end

  def date_range(week_year)
    week = week_year[4..5].to_i
    year = week_year[0..3].to_i
    return Date.commercial(year, week).years_ago(1), Date.commercial(year, week).years_since(1)
  end
end
