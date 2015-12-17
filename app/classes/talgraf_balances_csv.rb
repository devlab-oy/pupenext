require 'csv'

class TalgrafBalancesCsv
  def initialize(company_id:, column_separator: ',')
    @company = ::Company.find company_id
    Current.company = @company

    @options = { col_sep: column_separator }
  end

  def csv_data
    CSV.generate(@options) do |csv|
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

      params = { company: company }

      @data  = Header.new(params).rows
      @data += Company.new(params).rows
      @data += AccountingPeriods.new(params).rows
      @data += Accounts.new(params).rows
      @data += Dimensions.new(params).rows
      @data += AccountingUnits.new(params).rows
      @data += BalanceData.new(params).rows
      @data
    end

    def company
      @company
    end
end

class TalgrafBalancesCsv::Header
  def initialize(company:)
    @company = company
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
      ["timestamp", "#{Time.now}"]
    end

    def info
      year_begin = @company.current_fiscal_year.first.year
      year_end   = @company.current_fiscal_year.last.year

      info = "Balances #{year_begin}"
      info << " - #{year_end}" if year_end != year_begin
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
  def initialize(company:)
    @company = company
  end

  def rows
    data = []
    data << header_row
    data << period(start: company.current_fiscal_year.first, stop: company.current_fiscal_year.last)
    data << period(start: company.previous_fiscal_year.first, stop: company.previous_fiscal_year.last)
    data << footer_row
    data
  end

  private

    def company
      @company
    end

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

  def rows
    data = []
    data << header_row
    data += balance_sheet
    data += profit_and_loss
    data << footer_row
    data
  end

  private

    def company
      @company
    end

    def header_row
      ["BEGIN", "Accounts"]
    end

    def balance_sheet
      # tasetilit
      company.accounts.balance_sheet_accounts.order(:tilino).map do |account|
        ["account", account.tilino, account.nimi, "balance"]
      end
    end

    def profit_and_loss
      # tulostilit
      company.accounts.profit_and_loss_accounts.order(:tilino).map do |account|
        ["account", account.tilino, account.nimi, "closing"]
      end
    end

    def footer_row
      ["END"]
    end
end

class TalgrafBalancesCsv::Dimensions
  def initialize(company:)
    @company = company
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

    def company
      @company
    end

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

    def company
      @company
    end

    def header_row
      ["BEGIN", "AccountingUnits"]
    end

    def cost_centers
      # kustannuspaikka
      company.cost_centers.in_use.map do |cost_center|
        ["unit", cost_center.tyyppi, cost_center.tunnus, cost_center.nimi]
      end
    end

    def projects
      # projektit
      company.projects.in_use.map do |project|
        ["unit", project.tyyppi, project.tunnus, project.nimi]
      end
    end

    def targets
      # kohteet
      company.targets.in_use.map do |target|
        ["unit", target.tyyppi, target.tunnus, target.nimi]
      end
    end

    def footer_row
      ["END"]
    end
end

class TalgrafBalancesCsv::BalanceData
  def initialize(company:)
    @company = company
  end

  def rows
    data = []
    data << header_row
    data << entry_months
    data += opening_balance_rows
    data += voucher_rows
    data << footer_row
    data
  end

  private

    def company
      @company
    end

    def header_row
      ["BEGIN", "BalanceData"]
    end

    def entry_months
      previous = company.previous_fiscal_year.first.strftime("%Y-%m")
      current = company.current_fiscal_year.last.strftime("%Y-%m")

      ['entry-months', previous, current]
    end

    def opening_balance_rows
      tapvm = [company.previous_fiscal_year.first, company.current_fiscal_year.first]

      company.voucher_rows.includes(:voucher).where(lasku: { alatila: :A, tapvm: tapvm }).map do |row|

        row.selite.gsub! "\r", "" if row.selite
        row.selite.gsub! "\n", "" if row.selite

        [
          'ei',
          row.tapvm,
          row.summa,
          row.tilino,
          row.kustp,
          row.projekti,
          row.kohde,
          row.voucher.laskunro,
          row.selite
        ]
      end
    end

    def voucher_rows
      tapvm = company.previous_fiscal_year.first
      alatilat = [:A, :T]

      company.voucher_rows.includes(:voucher).where('lasku.tapvm >= ?', tapvm).where.not(lasku: { alatila: alatilat }).order(:tapvm).map do |row|

        row.selite.gsub! "\r", "" if row.selite
        row.selite.gsub! "\n", "" if row.selite

        [
          'e',
          row.tapvm,
          row.summa,
          row.tilino,
          row.kustp,
          row.projekti,
          row.kohde,
          row.voucher.laskunro,
          row.selite
        ]
      end
    end

    def footer_row
      ["END"]
    end
end
