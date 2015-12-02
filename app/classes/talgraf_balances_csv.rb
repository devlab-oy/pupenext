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

        HeaderRow.new(params).data.each { |row| @data << row }
        CompanyRow.new(company: @company).data.each { |row| @data << row }
        AccountingPeriodRow.new(company: @company).data.each { |row| @data << row }
        AccountsRow.new(company: @company).data.each { |row| @data << row }
      end

      @data
    end
end

class TalgrafBalancesCsv::HeaderRow
  def initialize(period_beginning:, period_end: '')
    @period_beginning = period_beginning
    @period_end = period_end
  end

  def data
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

class TalgrafBalancesCsv::CompanyRow
  def initialize(company:)
    @company = company
  end

  def data
    [
      ["BEGIN", "Company"],
      ["id", @company.ytunnus],
      ["name", @company.nimi],
      ["END"]
    ]
  end
end

class TalgrafBalancesCsv::AccountingPeriodRow
  def initialize(company:)
    @company = company
  end

  def data
    [
      ["BEGIN", "AccountingPeriods"],
      ["period", @company.tilikausi_alku, @company.tilikausi_loppu],
      ["END"]
    ]
  end
end

class TalgrafBalancesCsv::AccountsRow
  def initialize(company:)
    @company = company
  end

  def company
    @company
  end

  def data

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
