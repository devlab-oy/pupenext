class Import::ProductKeyword
  def initialize(company_id:, user_id:, filename:)
    Current.company = Company.find_by company_id
    Current.user = User.find_by user_id

    @file = setup_file filename
  end

  def import
    first_row = true

    spreadsheet.parse(header_search: header_definitions) do |excel_row|
      if first_row
        response.add_headers names: excel_row.values
        first_row = false
        next
      end

      row = Row.new excel_row

      errors = []

      if row.product.nil?
        errors << I18n.t('errors.import.product_not_found', product: row.product_raw)
      elsif row.keyword.nil?
        errors << I18n.t('errors.import.keyword_not_found', keyword: row.key, language: row.language)
      elsif !row.create
        errors << row.keyword.errors.full_messages
      end

      response.add_row columns: excel_row.values, errors: errors.flatten
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

    def header_definitions
      [
        'tuoteno',
        'laji',
        'selite',
        'selitetark',
        'kieli',
        'jarjestys',
        'nakyvyys',
        'toiminto',
      ]
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
    @tuoteno  = @hash.delete 'tuoteno'
    @toiminto = @hash.delete 'toiminto'
  end

  def product
    @product ||= Product.find_by tuoteno: @tuoteno
  end

  def product_raw
    @tuoteno
  end

  def key
    values['laji']
  end

  def language
    language = values['kieli']
    return language unless product

    values['kieli'] ? values['kieli'] : product.company.kieli
  end

  def keyword
    return unless product
    return @keyword if @keyword

    if add_new?
      @keyword = product.keywords.build
    else
      @keyword = product.keywords.find_by(laji: values['laji'], kieli: language)
    end
  end

  def create
    return if !product || keyword.nil?

    @hash[:kieli] = product && values['kieli'].blank? ? @product.company.kieli : language

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
