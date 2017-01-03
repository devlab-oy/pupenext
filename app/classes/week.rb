class Week
  def initialize(date)
    @date = Date.parse(date.to_s)
  end

  def human
    "#{week_number} / #{year}"
  end

  def compact
    "#{year}#{week_number}"
  end

  def year
    @date.cwyear
  end

  def week_number
    @date.cweek.to_s.rjust(2, '0')
  end
end
