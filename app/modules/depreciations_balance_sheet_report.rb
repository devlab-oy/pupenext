class DepreciationsBalanceSheetReport
  attr_accessor :current_company

  def initialize(company_id)
    self.current_company = Company.find_by(tunnus: company_id)
  end

  def accounts
    current_company.accounts.evl_accounts
  end
end

