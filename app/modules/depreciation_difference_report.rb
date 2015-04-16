class DepreciationDifferenceReport
  attr_accessor :current_company

  def initialize(company_id)
    self.current_company = Company.find_by(tunnus: company_id)
  end

  def accounts
    current_company.accounts.evl_accounts
  end

  def commodity_accounts
    current_company.voucher_rows.where.not(commodity_id: nil).map(&:tilino).uniq
  end

  def commodity_ids
    current_company.voucher_rows.where.not(commodity_id: nil).map(&:commodity_id).uniq
  end

  def opening_balance(account)
    current_company.voucher_rows.where(tilino: account.tilino, selite: 'Avaava tase').first.summa
  end
end
