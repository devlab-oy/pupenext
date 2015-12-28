class Reports::DepreciationDifferenceReport
  attr_accessor :company, :start_date, :end_date, :group_by

  def initialize(company_id:, start_date:, end_date:, group_by:)
    self.company    = Company.find company_id
    self.start_date = Date.parse start_date.to_s
    self.end_date   = Date.parse end_date.to_s
    self.group_by   = group_by.to_sym
  end
end

