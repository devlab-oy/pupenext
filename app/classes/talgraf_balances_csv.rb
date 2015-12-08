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
      return @data if @data

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
      @data
    end
end

class TalgrafBalancesCsv::Header
  def initialize(period_beginning:, period_end: nil)
    @period_beginning = period_beginning
    @period_end = period_end
  end

  def rows
    data = []
    data << header_row
    data << file_version
    data << tgi_id
    data << timestamp
    data << info
    data << footer_row
    data
  end

  private

    def header_row
      ["BEGIN", "Header"]
    end

    def footer_row
      ["END"]
    end

    # File's version number (integer)
    # Current version number is 0
    def file_version
      ["file_version", 0]
    end

    # Interface id
    def tgi_id
      ["tgi-id", "Intime"]
    end

    def timestamp
      ["timestamp", "#{DateTime.now}"]
    end

    def info
      info = "Balances #{@period_beginning}"
      info << " - #{@period_end}" if @period_end && @period_end != @period_beginning
      ["info", info]
    end
end

class TalgrafBalancesCsv::Company
  def initialize(company:)
    @company = company
  end

  def rows
    data = []
    data << header_row
    data << id
    data << name
    data << footer_row
    data
  end

  private

    def header_row
      ["BEGIN", "Company"]
    end

    def id
      ["id", @company.ytunnus]
    end

    def name
      ["name", @company.nimi]
    end

    def footer_row
      ["END"]
    end
end

class TalgrafBalancesCsv::AccountingPeriods
  def initialize(current:, previous:)
    @current = current
    @previous = previous
  end

  def rows
    data = []
    data << header_row
    data << period(start: @current.tilikausi_alku, stop: @current.tilikausi_loppu)
    data << period(start: @previous.tilikausi_alku, stop: @previous.tilikausi_loppu)
    data << footer_row
    data
  end

  private

    def header_row
      ["BEGIN", "AccountingPeriods"]
    end

    def period(start:, stop:)
      ["period", start, stop]
    end

    def footer_row
      ["END"]
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
    data = []
    data << header_row
    data += balance_sheet
    data += profit_and_loss
    data << footer_row
    data
  end

  private

    def header_row
      ["BEGIN", "Accounts"]
    end

    def balance_sheet
      data = []

      # tasetilit
      company.accounts.balance_sheet_accounts.order(:tilino).each do |account|
        data <<  ["account", account.tilino, account.nimi, "balance"]
      end

      data
    end

    def profit_and_loss
      data = []

      # tulostilit
      company.accounts.profit_and_loss_accounts.order(:tilino).each do |account|
        data << ["account", account.tilino, account.nimi, "closing"]
      end

      data
    end

    def footer_row
      ["END"]
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

    data = []
    data << header_row
    data += cost_centers
    data += projects
    data += targets
    data << footer_row
    data
  end

  private

    def header_row
      ["BEGIN", "Dimensions"]
    end

    def cost_centers
      data = []

      # kustannuspaikka
      cost_center = company.cost_centers.in_use.first
      data << ["dimension", cost_center.tyyppi, "Kustannuspaikka"] if cost_center.present?

      data
    end

    def projects
      data = []

      # projektit
      project = company.projects.in_use.first
      data << ["dimension", project.tyyppi, "Projekti"] if project.present?

      data
    end

    def targets
      data = []

      # kohteet
      target = company.targets.in_use.first
      data << ["dimension", target.tyyppi, "Kohde"] if target.present?

      data
    end

    def footer_row
      ["END"]
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

    data = []
    data << header_row
    data += cost_centers
    data += projects
    data += targets
    data << footer_row
    data
  end

  private

    def header_row
      ["BEGIN", "AccountingUnits"]
    end

    def cost_centers
      data = []

      # kustannuspaikka
      company.cost_centers.in_use.each do |cost_center|
        data << ["unit", cost_center.tyyppi, cost_center.tunnus, cost_center.nimi]
      end

      data
    end

    def projects
      data = []

      # projektit
      company.projects.in_use.each do |project|
        data << ["unit", project.tyyppi, project.tunnus, project.nimi]
      end

      data
    end

    def targets
      data = []

      # kohteet
      company.targets.in_use.each do |target|
        data << ["unit", target.tyyppi, target.tunnus, target.nimi]
      end

      data
    end

    def footer_row
      ["END"]
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
