class DepreciationsBalanceSheetReport
  attr_accessor :current_company

  def initialize(company_id)
    self.current_company = Company.find_by(tunnus: company_id)
  end

  def data
    result = {}

    accounts = current_company.accounts.evl_accounts

    fiscals = current_company.fiscal_years

    accounts.each do |acc|
      # Loopataan jokainen tili

      # acc.tilino
      resu = result[acc.tilino] = {}

      # acc.nimi
      resu[:nimi] = acc.nimi

      poistoaika = acc.commodity.planned_depreciation_type == 'T' ? acc.commodity.planned_depreciation_amount.to_i : 0
      resu[:poistoaika] = poistoaika

      resu[:tilikaudet] = {}

      fiscals.each do |fisk|

        fiscal_start = fisk.tilikausi_alku
        fiscal_end = fisk.tilikausi_loppu

        # tilikaus
        #resu2 = resu[:tilikaudet] = {}
        tkausitiedot = resu[:tilikaudet]["#{fisk.id}#{acc.tilino}"] = {}

        tkausitiedot[:tilikausi] = "#{fiscal_start} - #{fiscal_end}"
        # Tapahtumat tilikauden aikana yhteensa

        # tilikaud.hankinnat
        tkausitiedot[:hankinnat] = sum_by_fy_acc([fiscal_start..fiscal_end], acc.tilino)

        #tkausitiedot[:tilikausi_after] = current_company.voucher_row.where(tilino: acc.commodity.)

        # tilikaud.poisto
        # sum tiliointi.summa where pvm = fisk and commodity_id = nil and tilino = acc.taso.poistotili

        # kertynyt poisto where pvm < fiscal_end

        # menojaannos

      end

    end

    result
  end

  private

    def sum_by_fy_acc(fy, acctnmbr)
      all = current_company.commodities.where(activated_at: fy).map { |x| x.id if x.fixed_assets_account == acctnmbr}.compact
      current_company.commodities.where(id: all).sum(:amount).to_s
    end

  # def accounts
  #   current_company.accounts.evl_accounts
  # end
end

