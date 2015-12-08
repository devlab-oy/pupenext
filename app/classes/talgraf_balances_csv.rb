require 'csv'

class TalgrafBalancesCsv
  def initialize(company_id:)
    @company = ::Company.find company_id
    Current.company = @company

    @current = @company.fiscal_years.order(tunnus: :desc).last
    @previous = @company.fiscal_years.where("tilikausi_loppu < ?", @current.tilikausi_alku).order(tunnus: :desc).last
  end

  def csv_data
    CSV.generate do |csv|
      data.map { |row| csv << row }
    end
  end

  def to_file
    filename = Tempfile.new ["talgraf_balances-", ".csv"]

    CSV.open(filename, "wb", @options) do |csv|
      data.map { |row| csv << row }
    end

    filename.path
  end

  private

    def data
      if @data.blank?
        params = {
          period_beginning: @current.tilikausi_alku.year,
          period_end: @current.tilikausi_loppu.year
        }

        @data  = TalgrafBalancesCsv::Header.new(params).rows
        @data += TalgrafBalancesCsv::Company.new(company: @company).rows
        @data += TalgrafBalancesCsv::AccountingPeriods.new(current: @current, previous: @previous).rows
        @data += TalgrafBalancesCsv::Accounts.new(company: @company).rows
        @data += TalgrafBalancesCsv::Dimensions.new(company: @company).rows
        @data += TalgrafBalancesCsv::AccountingUnits.new(company: @company).rows

        params = {
          company: @company,
          current_fiscal: @current,
          previous_fiscal: @previous
        }

        @data += TalgrafBalancesCsv::BalanceData.new(params).rows
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
      info << " - #{@period_end}" if @period_end.present? && @period_end != @period_beginning
      info
    end
end

class TalgrafBalancesCsv::Company
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

class TalgrafBalancesCsv::AccountingPeriods
  def initialize(current:, previous:)
    @current = current
    @previous = previous
  end

  def rows
    [
      ["BEGIN", "AccountingPeriods"],
      ["period", @previous.tilikausi_alku, @previous.tilikausi_loppu],
      ["period", @current.tilikausi_alku, @current.tilikausi_loppu],
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

class TalgrafBalancesCsv::Dimensions
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
    cost_center = company.cost_centers.first
    data << ["dimension", cost_center.tyyppi, "Kustannuspaikka"] if cost_center.present?

    # projektit
    project = company.projects.first
    data << ["dimension", project.tyyppi, "Projekti"] if project.present?

    # kohteet
    target = company.targets.first
    data << ["dimension", target.tyyppi, "Kohde"] if target.present?

    data << ["END"]
    data
  end
end

class TalgrafBalancesCsv::AccountingUnits
  def initialize(company:)
    @company = company
  end

  def company
    @company
  end

  def rows

    data = [
      ["BEGIN", "AccountingUnits"],
    ]

    # kustannuspaikka
    company.cost_centers.each do |cost_center|
      data << ["unit", cost_center.tyyppi, cost_center.tunnus, cost_center.nimi]
    end

    # projektit
    company.projects.each do |project|
      data << ["unit", project.tyyppi, project.tunnus, project.nimi]
    end

    # kohteet
    company.targets.each do |target|
      data << ["unit", target.tyyppi, target.tunnus, target.nimi]
    end

    data << ["END"]
    data
  end
end

class TalgrafBalancesCsv::BalanceData
  def initialize(company:, current_fiscal:, previous_fiscal:)
    @company = company
    @current_fiscal = current_fiscal
    @previous_fiscal = previous_fiscal
  end

  def company
    @company
  end

  def rows
    data = []
    data << header_row
    data << entry_months
    data << opening_balance_rows
    data << voucher_rows
    data << footer_row
    data
  end

  private

    def header_row
      ["BEGIN", "BalanceData"]
    end

    def entry_months
      previous = "#{@previous_fiscal.tilikausi_alku.year}-#{@previous_fiscal.tilikausi_alku.month}"
      current = "#{@current_fiscal.tilikausi_loppu.year}-#{@current_fiscal.tilikausi_loppu.month}"

      ['entry-months', previous, current]
    end

    def opening_balance_rows
      balance_rows = []

      company.vouchers.opening_balance.where(tapvm: @current_fiscal.tilikausi_alku).each do |voucher|
        voucher.rows.select(:tapvm, :summa, :tilino, :kustp, :kohde, :projekti, :selite).each do |balance|
          balance_rows << [
            'ei',
            balance.tapvm,
            balance.summa,
            balance.tilino,
            balance.kustp,
            balance.projekti,
            balance.kohde,
            voucher.laskunro,
            balance.selite
          ]
        end
      end

      balance_rows
    end

    def voucher_rows
      balance_rows = []

      company.vouchers.exclude_opening_balance.order(:tapvm).each do |voucher|
        voucher.rows.select(:tapvm, :summa, :tilino, :kustp, :kohde, :projekti, :selite).each do |balance|
          balance_rows << [
            'e',
            balance.tapvm,
            balance.summa,
            balance.tilino,
            balance.kustp,
            balance.projekti,
            balance.kohde,
            voucher.laskunro,
            balance.selite
          ]
        end
      end

      balance_rows
    end

    def footer_row
      ["END"]
    end
end
