class DepreciationDifferenceReport
  attr_accessor :current_company

  def initialize(company_id)
    self.current_company = Company.find_by(tunnus: company_id)
  end

  def data
    result = {}

    accounts = current_company.accounts.evl_accounts

    fiscal = current_company.current_fiscal_year

    accounts.each do |acc|
      # Loopataan jokainen tili

      # acc.tilino
      resu = result[acc.tilino] = {}


      resu[:nimi] = acc.nimi

      resu[:lisaykset] = sum_by_fy_acc(fiscal, acc.tilino)
      resu[:evl_poistot] = evls_between(fiscal.first, fiscal.last, acc.tilino) * -1
      resu[:sumu_poistot] = depreciations_between(fiscal.first, fiscal.last, acc.tilino) * -1
      resu[:poistoero] = resu[:sumu_poistot] - resu[:evl_poistot]
      resu[:menojaannos] = residue_at(fiscal.last, acc.tilino)
      resu[:kum_poistoero] = accumulated_differences(fiscal.end, acc.tilino) * -1
    end

    result
  end

  private

    def sum_by_fy_acc(fy, acctnmbr)
      all = current_company.commodities.where(activated_at: fy).map { |x| x.id if x.fixed_assets_account == acctnmbr}.compact
      current_company.commodities.where(id: all).sum(:amount)
    end

    def depreciations_between(date1, date2, acctnmbr)
      all = current_company.commodities.where(status: 'A').map { |x| x.id if x.fixed_assets_account == acctnmbr}.compact
      current_company.commodities.where(id: all).map { |x| x.depreciation_between(date1, date2) }.sum
    end

    def evls_between(date1, date2, acctnmbr)
      all = current_company.commodities.where(status: 'A').map { |x| x.id if x.fixed_assets_account == acctnmbr}.compact
      current_company.commodities.where(id: all).map { |x| x.evl_between(date1, date2) }.sum
    end

    def accumulated_differences(date, acctnmbr)
      all = current_company.commodities.where(status: 'A').map { |x| x.id if x.fixed_assets_account == acctnmbr}.compact
      current_company.commodities.where(id: all).map { |x| x.accumulated_difference_at(date) }.sum
    end

    def residue_at(date, acctnmbr)
      all = current_company.commodities.where(status: 'A').where('activated_at <= ?', date).map { |x| x.id if x.fixed_assets_account == acctnmbr}.compact
      sum1 = current_company.commodities.where(id: all).map { |x| x.bookkeeping_value(date) }.sum
      sum2 = current_company.commodities.where(id: all).map { |x| x.accumulated_depreciation_at(date) }.sum
      sum1 - sum2
    end
end
