class Import::ProductKeyword
  def initialize(company_id:, user_id:, filename:)
    Current.company = Company.find_by company_id
    Current.user = User.find_by user_id

    @file = setup_file filename
  end

  def import
    first_row = true

    spreadsheet.each(column_definitions) do |excel_row|

      if first_row
        response.add_headers names: excel_row.values
        first_row = false
        next
      end

      row = Row.new excel_row

      errors = []
      errors << I18n.t('errors.import.product_not_found', product: excel_row[:tuoteno]) if row.product.nil?
      errors << row.keyword.errors.full_messages if row.product && !row.create

      response.add_row columns: excel_row.values, errors: errors
    end

    response
  end

  private

    def response
      @response ||= Import::Response.new
    end

    def spreadsheet
      @file.sheet(0)
    end

    def column_definitions
      {
        tuoteno:    'tuoteno',
        laji:       'laji',
        selite:     'selite',
        selitetark: 'selitetark',
        kieli:      'kieli',
        jarjestys:  'jarjestys',
        nakyvyys:   'nakyvyys',
        toiminto:   'toiminto',
      }
    end

    def add_error(message)
      @errors << message
    end

    def setup_file(filename)
      # if we have an rails UploadedFile class
      if filename.respond_to?(:original_filename)
        file = filename.open
        extension = File.extname filename.original_filename
      else
        file = File.open filename.to_s
        extension = File.extname filename.to_s
      end

      Roo::Spreadsheet.open file, extension: extension
    ensure
      file.close if file
    end
end

class Import::ProductKeyword::Row
  def initialize(hash)
    @hash     = hash.dup
    @tuoteno  = @hash.delete :tuoteno
    @toiminto = @hash.delete :toiminto
  end

  def product
    @product ||= Product.find_by tuoteno: @tuoteno
  end

  def keyword
    return unless product

    @keyword ||= product.keywords.find_or_create_by(laji: values[:laji], kieli: values[:kieli])
  end

  def create
    return unless product

    keyword.attributes = values
    keyword.save
  end

  def values
    hash = @hash
    hash.each { |k, v| hash[k] = '' if hash[k].nil? }
    hash
  end

  def add_new?
    %w(lisää lisÄÄ lisaa).include? @toiminto.to_s.downcase
  end
end
