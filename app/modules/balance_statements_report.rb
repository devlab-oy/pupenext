class BalanceStatementsReport
  attr_accessor :current_company, :fiscal_start, :fiscal_end

  def initialize(company_id, fiscal_id = nil)
    self.current_company = Company.find_by(tunnus: company_id)

    fi = fiscal_id ? current_company.fiscal_years.find(fiscal_id).period : current_company.current_fiscal_year
    self.fiscal_start = fi.first
    self.fiscal_end   = fi.last
  end

  # palauttaa kokoelman jossa on kaikki raportin rivit
  def data
    arzka = {}

    # loopataan kaikki evl-tasot ja haetaan kaikki tiedot seka laitetaan ne arzkaan
    current_company.sum_level_commodities.each do |slc|
      hydyt = kaikki_tason_hyodykkeet(slc)

      # arzkan roottilevelin key on aina taso
      thislevel = arzka[slc.taso] = {}

      # keyn selite
      thislevel[:nimi] = slc.nimi

      # Kaikkien hyodykkeiden yhteenlaskettu hankintameno
      thislevel[:hankintameno] = hydyt.sum(:amount)

      # sumupoistot tilikauden alussa
      thislevel[:kert_sumupoisto_before] = hydyt.map { |h| h.accumulated_depreciation_at(fiscal_start) }.sum
      #sumupoistot laskettavalla tilikaudella
      thislevel[:sumupoisto] = hydyt.map { |h| h.accumulated_depreciation_at(fiscal_end) }.sum - thislevel[:kert_sumupoisto_before]
      # sumupoistot yhteensa
      thislevel[:kert_sumupoisto_after] = thislevel[:kert_sumupoisto_before] +  thislevel[:sumupoisto]

      # poistoerot tilikauden alussa
      thislevel[:kert_poistoero_before] = hydyt.map { |h| h.accumulated_difference_at(fiscal_start) }.sum
      # poistoerot laskettavalla tilikaudella
      thislevel[:kert_poistoero] = hydyt.map { |h| h.accumulated_difference_at(fiscal_end) }.sum - thislevel[:kert_poistoero_before]
      # poistoerot yhteensa
      thislevel[:kert_poistoero_after] = thislevel[:kert_poistoero_before] + thislevel[:kert_poistoero]

      # evl poistot yhteensa
      thislevel[:kert_evl_after] = hydyt.map { |h| h.accumulated_evl_at(fiscal_end) }.sum


      # poistamaton osa
      thislevel[:poistamaton_osa] = hydyt.map { |h| h.bookkeeping_value(fiscal_end) }.sum
    end

    arzka
  end

  private

    def kaikki_tason_hyodykkeet(sumlevel)
      # kaikki tilinumerot tileiltä, joilla on tämä taso
      tilinumerot = current_company.accounts.where(evl_taso: sumlevel.taso).map(&:tilino).uniq

      # kaikki hyödyke_idt joilla on hankintakustannus ylläolevilla tileillä
      hyodyke_idt = current_company.voucher_rows.where(tilino: tilinumerot).map(&:commodity_id).uniq

      # kaikki ylläolevien tunnusten hyödykkeet
      current_company.commodities.where(id: hyodyke_idt)
    end
end
