module ReportHelper
  def month_options
    %w(1 2 3 6 12).map do |m|
      [ t("reports.revenue_expenditure_month", count: m.to_i), m ]
    end
  end
end
