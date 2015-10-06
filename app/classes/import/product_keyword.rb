class Import::ProductKeyword
  def initialize(filename)
    @file = setup_file filename
    @errors = []

    Current.user = User.find_by kuka: 'joe'
  end

  def import
    spreadsheet.each(column_definitions) do |excel_row|
      row = Row.new excel_row

      if row.product.nil?
        add_error I18n.t('errors.messages.invalid')
        next
      end

      if !row.create
        add_error row.keyword.errors.full_messages
        next
      end
    end
  end

  def errors
    @errors
  end

  private

    def spreadsheet
      @file.sheet(0)
    end

    def column_definitions
      {
        jarjestys:  'jarjestys',
        kieli:      'kieli',
        laji:       'laji',
        nakyvyys:   'nakyvyys',
        selite:     'selite',
        selitetark: 'selitetark',
        toiminto:   'toiminto',
        tuoteno:    'tuoteno',
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
    @tuoteno  = hash.delete :tuoteno
    @toiminto = hash.delete :toiminto
    @hash     = hash
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
