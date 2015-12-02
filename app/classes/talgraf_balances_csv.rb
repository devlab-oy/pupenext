require 'csv'

class TalgrafBalancesCsv
  def initialize(company_id:, period_beginning:, period_end: '')
    @company = Company.find company_id
    Current.company = @company

    @period_beginning = period_beginning
    @period_end = period_end
  end

  def csv_data
    CSV.generate do |csv|
      data.map { |row| csv << row }
    end
  end

  private

    def data
      if @data.blank?
        @data = []

        params = {
          period_beginning: @period_beginning,
          period_end: @period_end
        }

        TalgrafBalancesCsv::Header.new(params).rows.each { |row| @data << row }
        TalgrafBalancesCsv::Corporation.new(company: @company).rows.each { |row| @data << row }
        TalgrafBalancesCsv::AccountingPeriod.new(company: @company).rows.each { |row| @data << row }
        TalgrafBalancesCsv::Accounts.new(company: @company).rows.each { |row| @data << row }
        TalgrafBalancesCsv::Qualifiers.new(company: @company).rows.each { |row| @data << row }
      end

      @data
    end
end

class TalgrafBalancesCsv::Header
  def initialize(period_beginning:, period_end: '')
    @period_beginning = period_beginning
    @period_end = period_end
  end

  def rows
    [
      ["BEGIN", "Header"],
      ["file_version", file_version],
      ["tgi-id", tgi_id],
      ["timestamp", DateTime.now],
      ["info", info],
      ["END"]
    ]
  end

  private

    # File's version number (integer)
    # Current version number is 0
    def file_version
      0
    end

    # Interface id
    def tgi_id
      "Intime"
    end

    def info
      info = "Balances #{@period_beginning}"
      info << " - #{@period_end}" if @period_end.present?
      info
    end
end

class TalgrafBalancesCsv::Corporation
  def initialize(company:)
    @company = company
  end

  def rows
    [
      ["BEGIN", "Company"],
      ["id", @company.ytunnus],
      ["name", @company.nimi],
      ["END"]
    ]
  end
end

class TalgrafBalancesCsv::AccountingPeriod
  def initialize(company:)
    @company = company
  end

  def rows

    current = @company.fiscal_years.order(tunnus: :desc).last
    previous = @company.fiscal_years.where("tilikausi_loppu < ?", current.tilikausi_alku).order(tunnus: :desc).last

    [
      ["BEGIN", "AccountingPeriods"],
      ["period", previous.tilikausi_alku, previous.tilikausi_loppu],
      ["period", current.tilikausi_alku, current.tilikausi_loppu],
      ["END"]
    ]
  end
end

class TalgrafBalancesCsv::Accounts
  def initialize(company:)
    @company = company
  end

  def company
    @company
  end

  def rows

    data = [
      ["BEGIN", "Accounts"],
    ]

    # tasetilit
    company.accounts.balance_sheet_accounts.each do |account|
      data << ["account", account.tilino, account.nimi, "balance"]
    end

    # tulostilit
    company.accounts.profit_and_loss_accounts.each do |account|
      data << ["account", account.tilino, account.nimi, "closing"]
    end

    data << ["END"]
    data
  end
end

class TalgrafBalancesCsv::Qualifiers
  def initialize(company:)
    @company = company
  end

  def company
    @company
  end

  def rows

    data = [
      ["BEGIN", "Dimensions"],
    ]

    # kustannuspaikka
    company.cost_centers.each do |cost_center|
      data << ["dimension", cost_center.tunnus, cost_center.nimi]
    end

    # projektit
    company.projects.each do |project|
      data << ["dimension", project.tunnus, project.nimi]
    end

    # kohteet
    company.targets.each do |target|
      data << ["dimension", target.tunnus, target.nimi]
    end

    data << ["END"]
    data
  end
end
