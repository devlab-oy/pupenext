module Administration::DepartureHelper
  ROOT = 'administration.delivery_methods.departures'

  def day_of_the_week_options
    Date::DAYS_INTO_WEEK.inject([]) do |result, day|
      index = day.first == :sunday ? 0 : day.second + 1
      result << [t("#{ROOT}.day_of_the_week_options.#{day.first}"), index]
    end
  end

  def terminal_area_options
    Keyword::TerminalArea.order(:label, :code).pluck(:label, :code) do |c|
      [ c.label, c.code ]
    end
  end

  def customer_group_options
    Keyword::CustomerGroup.order(:label, :code).pluck(:label, :code) do |c|
      [ c.label, c.code ]
    end
  end

  def warehouse_options
    Warehouse.order(:nimitys).pluck(:nimitys, :tunnus) do |c|
      [ c.nimitys, c.tunnus ]
    end
  end

  def status_options
    [
      [ t("#{ROOT}.status_options.in_use"), :in_use ],
      [ t("#{ROOT}.status_options.not_in_use"), :not_in_use ],
    ]
  end
end
