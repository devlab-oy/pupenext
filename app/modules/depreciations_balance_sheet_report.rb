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

      # Kerataan koko tilikauden totalit
      resu[:hankinnat_yht] = 0
      resu[:tilikauden_poistot_yht] = 0
      resu[:kertynyt_poisto_yht] = 0
      resu[:menojaannos_yht] = 0

      resu[:tilikaudet] = {}

      fiscals.each do |fisk|

        fiscal_start = fisk.tilikausi_alku
        fiscal_end = fisk.tilikausi_loppu

        #resu2 = resu[:tilikaudet] = {}
        tkausitiedot = resu[:tilikaudet]["#{fisk.id}#{acc.tilino}"] = {}

        tkausitiedot[:tilikausi] = "#{I18n.l fiscal_start} - #{I18n.l fiscal_end}"
        # Tapahtumat tilikauden aikana yhteensa

        # tilikaud.hankinnat
        tkausitiedot[:hankinnat] = sum_by_fy_acc([fiscal_start..fiscal_end], acc.tilino)
        resu[:hankinnat_yht] += tkausitiedot[:hankinnat]

        # tilikaud.poistot
        tkausitiedot[:tilikauden_poistot] = depreciations_between(fiscal_start, fiscal_end, acc.tilino)
        resu[:tilikauden_poistot_yht] += tkausitiedot[:tilikauden_poistot]

        # kertynyt poisto
        tkausitiedot[:kertynyt_poisto] = bkvalue_at_end(fiscal_end, acc.tilino)
        resu[:kertynyt_poisto_yht] += tkausitiedot[:kertynyt_poisto]
        # menojaannos -- paljonko poistettavaa??
        tkausitiedot[:menojaannos] = tkausitiedot[:hankinnat].to_d - tkausitiedot[:kertynyt_poisto].to_d
        resu[:menojaannos_yht] += tkausitiedot[:menojaannos]
      end

    end

    result
  end

  private

    def sum_by_fy_acc(fy, acctnmbr)
      all = current_company.commodities.where(activated_at: fy).map { |x| x.id if x.fixed_assets_account == acctnmbr}.compact
      current_company.commodities.where(id: all).sum(:amount)
    end

    def depreciations_between(date1, date2, acctnmbr)
      all = current_company.commodities.where(activated_at: [date1..date2]).map { |x| x.id if x.fixed_assets_account == acctnmbr}.compact
      current_company.commodities.where(id: all).map { |x| x.depreciation_between(date1, date2) }.sum
    end

    def bkvalue_at_end(date, acctnmbr)
      all = current_company.commodities.where('activated_at <= ? ', date).map { |x| x.id if x.fixed_assets_account == acctnmbr}.compact
      current_company.commodities.where(id: all).map { |x| x.bookkeeping_value(date) }.sum
    end
end

