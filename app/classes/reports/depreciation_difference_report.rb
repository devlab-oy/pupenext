class Reports::DepreciationDifferenceReport
  attr_accessor :company, :start_date, :end_date, :group_by

  def initialize(company_id:, start_date:, end_date:)
    self.company    = Company.find company_id
    self.start_date = Date.parse start_date.to_s
    self.end_date   = Date.parse end_date.to_s

    Current.company = company
  end

  def data
    Response.new(company: company, date_range: date_range)
  end

  private

    def date_range
      start_date..end_date
    end

end

class Reports::DepreciationDifferenceReport::Response
  attr_accessor :company, :date_range

  def initialize(company:, date_range:)
    self.company    = company
    self.date_range = date_range
  end

  def sum_levels
    company.sum_level_commodities.map do |level|
      Reports::DepreciationDifferenceReport::SumLevel.new(sum_level: level, date_range: date_range)
    end
  end
end

class Reports::DepreciationDifferenceReport::SumLevel
  attr_accessor :sum_level, :date_range

  def initialize(sum_level:, date_range:)
    self.date_range = date_range
    self.sum_level  = sum_level
  end

  def accounts
    sum_level.accounts.map do |account|
      Reports::DepreciationDifferenceReport::Account.new(account: account, date_range: date_range)
    end
  end

  def name
    sum_level.nimi
  end
end

class Reports::DepreciationDifferenceReport::Account
  attr_accessor :account, :date_range

  def initialize(account:, date_range:)
    self.account    = account
    self.date_range = date_range
  end

  def commodities
    account.commodities.map do |commodity|
      Reports::DepreciationDifferenceReport::Commodity.new(commodity: commodity, date_range: date_range)
    end
  end

  def name
    account.nimi
  end
end

class Reports::DepreciationDifferenceReport::Commodity
  attr_accessor :commodity, :date_range

  def initialize(commodity:, date_range:)
    self.commodity  = commodity
    self.date_range = date_range
  end

  def name
    commodity.name
  end
end
