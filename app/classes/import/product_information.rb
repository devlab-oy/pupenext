require 'csv'

class Import::ProductInformation
  include Import::Base

  def initialize(company_id:, user_id:, filename:, language:, type:)
    Current.company = Company.find company_id
    Current.user = User.find user_id

    raise ArgumentError, "Invalid type" unless %w(information parameter keyword).include?(type)
    raise ArgumentError, "Invalid language" unless Dictionary.locales.include?(language)

    @file = setup_file filename
    @language = language
    @type = type
  end

  def import
    # we'll convert the excel to a CSV and pass it to Import::ProductKeyword
    filename = Tempfile.new ['product-keywords', '.csv']

    CSV.open(filename, 'w') do |csv|
      converted_spreadsheet.each { |row| csv << row }
    end

    Import::ProductKeyword.new(
      company_id: Current.company.id,
      user_id: Current.user.id,
      filename: filename.path,
    ).import
  end

  private

    def converted_spreadsheet
      # here we convert this special excel format to array of product keyword records
      first_row = true
      excel = []

      # Loop trough file and assign keys for columns from whatever is given on the first row
      spreadsheet.parse(header_search: spreadsheet.row(1)) do |excel_row|
        rows = Row.new(excel_row, language: @language, type: @type)

        if first_row
          # add header row to excel array
          excel << rows.values.first.keys.map { |k| k.to_s }
          first_row = false
        else
          # add row values to excel array
          rows.values.each { |row| excel << row.values }
        end
      end

      excel
    end
end

class Import::ProductInformation::Row
  def initialize(hash, language:, type:)
    @hash     = Hash[hash.map { |k, v| [k.downcase, v] }] # downcase all keys
    @tuoteno  = @hash.delete 'tuotenumero'
    @toiminto = @hash.delete 'poista'
    @language = language
    @type     = type
  end

  def values
    # create a product keyword row out of every column
    @hash.map do |key, value|
      {
        tuoteno: @tuoteno,
        laji: laji_value(key),
        selite: value,
        kieli: @language,
        toiminto: action_value
      }
    end
  end

  def action_value
    @toiminto.to_s.downcase == 'x' ? 'POISTA' : 'MUOKKAA/LISÄÄ'
  end

  def laji_value(value)
    case @type
    when 'information'
      key = Keyword::ProductInformationType.find_by(selitetark: value).try(:selite)
      key ? "lisatieto_#{key}" : "LISÄTIETO: #{value}"
    when 'parameter'
      key = Keyword::ProductParameterType.find_by(selitetark: value).try(:selite)
      key ? "parametri_#{key}" : "PARAMETRI: #{value}"
    when 'keyword'
      Keyword::ProductKeywordType.find_by(selitetark: value).try(:selite) || "AVAINSANA: #{value}"
    else
      raise ArgumentError
    end
  end
end
