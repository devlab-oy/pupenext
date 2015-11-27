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
      spreadsheet.each do |spreadsheet_row|

        # create hash of the row (defined in Import::Base)
        excel_row = row_to_hash spreadsheet_row

        rows = Row.new(excel_row, language: @language, type: type_hash)

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

    def product_information
      @product_information ||= Keyword::ProductInformationType.select(:selite, :selitetark)
    end

    def product_parameter
      @product_parameter ||= Keyword::ProductParameterType.select(:selite, :selitetark)
    end

    def product_keyword
      @product_keyword ||= Keyword::ProductKeywordType.select(:selite, :selitetark)
    end

    def type_hash
      type = case @type
      when 'information'
        product_information
      when 'parameter'
        product_parameter
      when 'keyword'
        product_keyword
      else
        raise ArgumentError
      end

      hash = { type: @type }
      type.index_by { |r| r.selitetark.downcase }.merge(hash)
    end
end

class Import::ProductInformation::Row
  def initialize(hash, language:, type:)
    @hash     = Hash[hash.map { |k, v| [k.to_s.downcase, v] }] # downcase all keys
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
    key = @type[value.to_s].try(:selite)

    case @type[:type]
    when 'information'
      key ? "lisatieto_#{key}" : "LISÄTIETO: #{value}"
    when 'parameter'
      key ? "parametri_#{key}" : "PARAMETRI: #{value}"
    when 'keyword'
      key || "AVAINSANA: #{value}"
    else
      raise ArgumentError
    end
  end
end
