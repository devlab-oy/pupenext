class BalanceStatementsReport
  attr_accessor :current_company

  def initialize(company_id)
    self.current_company = Company.find_by(tunnus: company_id)
  end

  def vouchers_by_sumlevel(sum_level)
    accounts = current_company.accounts.where(evl_taso: sum_level.taso).map(&:tilino).uniq

    rows = current_company.voucher_rows.where(tilino: accounts).count
  end
end
