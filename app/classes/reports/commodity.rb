class Reports::Commodity
  attr_accessor :company, :start_date, :end_date

  def initialize(company_id:, start_date:, end_date:)
    self.company    = Company.find company_id
    self.start_date = Date.parse start_date.to_s
    self.end_date   = Date.parse end_date.to_s

    Current.company = company
  end

  # This report response is a top down hierarcial representation of commodities:
  # 1. Response contains an array of commodity sum_levels
  # 2. Sum_level contains an array of its accounts
  # 3. Account contains an array of its commodities
  # 4. Commodity contains the required data/calculations
  def data
    Response.new(company: company, date_range: date_range)
  end

  private

    def date_range
      start_date..end_date
    end

end

class Reports::Commodity::Response
  attr_accessor :company, :date_range

  def initialize(company:, date_range:)
    self.company    = company
    self.date_range = date_range
  end

  def sum_levels
    @sum_levels ||= external_sum_levels_with_commodity.map do |level|
      Reports::Commodity::SumLevel.new(sum_level: level, date_range: date_range)
    end
  end

  def depricatios_in_range
    sum_levels.sum &:depricatios_in_range
  end

  def differences_in_range
    sum_levels.sum &:differences_in_range
  end

  def btl
    sum_levels.sum &:btl
  end

  def procurement_amount
    sum_levels.sum &:procurement_amount
  end

  def opening_deprication
    sum_levels.sum &:opening_deprication
  end

  def opening_btl
    sum_levels.sum &:opening_btl
  end

  def closing_deprication
    sum_levels.sum &:closing_deprication
  end

  def closing_btl
    sum_levels.sum &:closing_btl
  end

  def opening_difference
    sum_levels.sum &:opening_difference
  end

  def closing_difference
    sum_levels.sum &:closing_difference
  end

  # kirjanpidollinen arvo jakson alussa
  def opening_bookkeeping_value
    sum_levels.sum &:opening_bookkeeping_value
  end

  # kirjanpidollinen arvo jakson lopussa
  def closing_bookkeeping_value
    sum_levels.sum &:closing_bookkeeping_value
  end

  # evl arvo jakson alussa
  def opening_btl_value
    sum_levels.sum &:opening_btl_value
  end

  # evl arvo jakson lopussa
  def closing_btl_value
    sum_levels.sum &:closing_btl_value
  end

  # hankintahinnan lisäykset aikavälillä (aktivoidut)
  def additions_in_range
    sum_levels.sum &:additions_in_range
  end

  # hankintahinnan vähennykset aikavälillä (myydyt)
  def deductions_in_range
    sum_levels.sum &:deductions_in_range
  end

  # kumulatiivinen hankintahinta aikavälin alussa
  def opening_procurement_amount
    sum_levels.sum &:opening_procurement_amount
  end

  # kumulatiivinen hankintahinta aikavälin lopussa
  def closing_procurement_amount
    sum_levels.sum &:closing_procurement_amount
  end

  private

    def external_sum_levels_with_commodity
      company.sum_level_externals.joins(:accounts).where.not(tili: { evl_taso: '' }).uniq
    end
end

class Reports::Commodity::SumLevel
  attr_accessor :sum_level, :date_range

  def initialize(sum_level:, date_range:)
    self.date_range = date_range
    self.sum_level  = sum_level
  end

  def accounts
    @accounts ||= sum_level.accounts.where.not(evl_taso: '').map do |account|
      Reports::Commodity::Account.new(account: account, date_range: date_range)
    end
  end

  def name
    "#{sum_level.taso} - #{sum_level.nimi}"
  end

  def depricatios_in_range
    accounts.sum &:depricatios_in_range
  end

  def differences_in_range
    accounts.sum &:differences_in_range
  end

  def btl
    accounts.sum &:btl
  end

  def procurement_amount
    accounts.sum &:procurement_amount
  end

  def opening_deprication
    accounts.sum &:opening_deprication
  end

  def opening_btl
    accounts.sum &:opening_btl
  end

  def closing_deprication
    accounts.sum &:closing_deprication
  end

  def closing_btl
    accounts.sum &:closing_btl
  end

  def opening_difference
    accounts.sum &:opening_difference
  end

  def closing_difference
    accounts.sum &:closing_difference
  end

  # kirjanpidollinen arvo jakson alussa
  def opening_bookkeeping_value
    accounts.sum &:opening_bookkeeping_value
  end

  # kirjanpidollinen arvo jakson lopussa
  def closing_bookkeeping_value
    accounts.sum &:closing_bookkeeping_value
  end

  # evl arvo jakson alussa
  def opening_btl_value
    accounts.sum &:opening_btl_value
  end

  # evl arvo jakson lopussa
  def closing_btl_value
    accounts.sum &:closing_btl_value
  end

  # hankintahinnan lisäykset aikavälillä (aktivoidut)
  def additions_in_range
    accounts.sum &:additions_in_range
  end

  # hankintahinnan vähennykset aikavälillä (myydyt)
  def deductions_in_range
    accounts.sum &:deductions_in_range
  end

  # kumulatiivinen hankintahinta aikavälin alussa
  def opening_procurement_amount
    accounts.sum &:opening_procurement_amount
  end

  # kumulatiivinen hankintahinta aikavälin lopussa
  def closing_procurement_amount
    accounts.sum &:closing_procurement_amount
  end
end

class Reports::Commodity::Account
  attr_accessor :account, :date_range

  def initialize(account:, date_range:)
    self.account    = account
    self.date_range = date_range
  end

  def commodities
    @commodities ||= account.commodities.map do |commodity|
      Reports::Commodity::Commodity.new(commodity: commodity, date_range: date_range)
    end
  end

  def name
    "#{account.tilino} - #{account.nimi}"
  end

  def depricatios_in_range
    commodities.sum &:depricatios_in_range
  end

  def differences_in_range
    commodities.sum &:differences_in_range
  end

  def btl
    commodities.sum &:btl
  end

  def procurement_amount
    commodities.sum &:procurement_amount
  end

  def opening_deprication
    commodities.sum &:opening_deprication
  end

  def opening_btl
    commodities.sum &:opening_btl
  end

  def closing_deprication
    commodities.sum &:closing_deprication
  end

  def closing_btl
    commodities.sum &:closing_btl
  end

  def opening_difference
    commodities.sum &:opening_difference
  end

  def closing_difference
    commodities.sum &:closing_difference
  end

  # kirjanpidollinen arvo jakson alussa
  def opening_bookkeeping_value
    commodities.sum &:opening_bookkeeping_value
  end

  # kirjanpidollinen arvo jakson lopussa
  def closing_bookkeeping_value
    commodities.sum &:closing_bookkeeping_value
  end

  # evl arvo jakson alussa
  def opening_btl_value
    commodities.sum &:opening_btl_value
  end

  # evl arvo jakson lopussa
  def closing_btl_value
    commodities.sum &:closing_btl_value
  end

  # hankintahinnan lisäykset aikavälillä (aktivoidut)
  def additions_in_range
    commodities.sum &:additions_in_range
  end

  # hankintahinnan vähennykset aikavälillä (myydyt)
  def deductions_in_range
    commodities.sum &:deductions_in_range
  end

  # kumulatiivinen hankintahinta aikavälin alussa
  def opening_procurement_amount
    commodities.sum &:opening_procurement_amount
  end

  # kumulatiivinen hankintahinta aikavälin lopussa
  def closing_procurement_amount
    commodities.sum &:closing_procurement_amount
  end
end

class Reports::Commodity::Commodity
  attr_accessor :commodity, :date_range

  def initialize(commodity:, date_range:)
    self.commodity  = commodity
    self.date_range = date_range
  end

  # hyödykkeen nimi
  def name
    commodity.name
  end

  # hyödykkeen hankintapäivä
  def procurement_date
    commodity.procurement_date
  end

  # hyödykkeen hankintahinta
  def procurement_amount
    commodity.procurement_amount
  end

  # kertyneet sumu-poistot jakson alussa
  def opening_deprication
    commodity.accumulated_depreciation_at date_range.first
  end

  # kertyneet sumu-poistot jakson lopussa
  def closing_deprication
    commodity.accumulated_depreciation_at date_range.last
  end

  # kertyneet evl-poistot jakson alussa
  def opening_btl
    commodity.accumulated_evl_at date_range.first
  end

  # kertyneet evl-poistot jakson lopussa
  def closing_btl
    commodity.accumulated_evl_at date_range.last
  end

  # kertyneet poistoerot jakson alussa
  def opening_difference
    commodity.accumulated_difference_at date_range.first
  end

  # kertyneet poistoerot jakson lopussa
  def closing_difference
    commodity.accumulated_difference_at date_range.last
  end

  # kirjanpidollinen arvo jakson alussa
  def opening_bookkeeping_value
    commodity.bookkeeping_value date_range.first
  end

  # kirjanpidollinen arvo jakson lopussa
  def closing_bookkeeping_value
    commodity.bookkeeping_value date_range.last
  end

  # evl arvo jakson alussa
  def opening_btl_value
    commodity.btl_value date_range.first
  end

  # evl arvo jakson lopussa
  def closing_btl_value
    commodity.btl_value date_range.last
  end

  # kertyneet sumu-poistot aikavälillä
  def depricatios_in_range
    @deprication ||= commodity.depreciation_between(date_range.first, date_range.last)
  end

  # kertyneet poistoerot aikavälillä
  def differences_in_range
    @differences_in_range ||= commodity.difference_between date_range.first, date_range.last
  end

  # kertyneet evl-poistot aikavälillä
  def btl
    @btl ||= commodity.evl_between date_range.first, date_range.last
  end

  # hankintahinnan lisäykset aikavälillä (aktivoidut)
  def additions_in_range
    if date_range.cover?(commodity.activated_at)
      commodity.amount
    else
      0.0
    end
  end

  # hankintahinnan vähennykset aikavälillä (myydyt)
  def deductions_in_range
    if date_range.cover?(commodity.deactivated_at)
      commodity.procurement_amount
    else
      0.0
    end
  end

  # kumulatiivinen hankintahinta aikavälin alussa
  def opening_procurement_amount
    if commodity.activated_at <= date_range.first
      commodity.procurement_amount
    else
      0.0
    end
  end

  # kumulatiivinen hankintahinta aikavälin lopussa
  def closing_procurement_amount
    opening_procurement_amount + additions_in_range - deductions_in_range
  end
end
