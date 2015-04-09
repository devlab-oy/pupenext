class DepreciationDifferenceReport
  def initialize(company_id)
    current_company = Company.find_by(tunnus: company_id)

    @sumlevels = current_company.sum_level_commodities
  end
end
