class Import::ProductKeyword
  include Import::Base

  def initialize(company_id:, user_id:, filename:)
    Current.company = Company.find company_id
    Current.user = User.find user_id

    @file = setup_file filename
  end

  def import
    first_row = true

    spreadsheet.each do |spreadsheet_row|

      # create hash of the row (defined in Import::Base)
      excel_row = row_to_hash spreadsheet_row

      if first_row
        response.add_headers names: excel_row.values.map(&:downcase)
        first_row = false
        next
      end

      row = Row.new excel_row

      errors = []

      if row.action.blank?
        errors << I18n.t('errors.import.action_missing')
      elsif !row.action_valid?
        errors << I18n.t('errors.import.action_incorrect')
      elsif row.product.nil?
        errors << I18n.t('errors.import.product_not_found', product: row.product_raw)
      elsif row.keyword.nil?
        errors << I18n.t('errors.import.keyword_not_found', keyword: row.key, language: row.language)
      elsif !row.valid_attributes?
        errors << I18n.t('errors.import.invalid_attributes', attributes: row.invalid_attributes.to_sentence)
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

end

class Import::ProductKeyword::Row
  def initialize(hash)
    @hash     = hash.dup
    @tuoteno  = @hash.delete 'tuoteno'
    @toiminto = @hash.delete 'toiminto'
  end

  def action
    @toiminto
  end

  def action_valid?
    add_new? || modify_row? || add_or_modify? || remove_row?
  end

  def invalid_attributes
    values.reject { |k,v| keyword.respond_to?(k) }.keys
  end

  def valid_attributes?
    values.all? { |k,_| keyword.respond_to?(k) }
  end

  def product
    return nil unless @tuoteno.present?

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

    if add_or_modify?
      @keyword = product.keywords.find_or_initialize_by(laji: values['laji'], kieli: language)
    elsif add_new?
      @keyword = product.keywords.build
    elsif modify_row? || remove_row?
      @keyword = product.keywords.find_by(laji: values['laji'], kieli: language)
    end
  end

  def create
    return if !product || keyword.nil?

    if remove_row?
      return keyword.destroy
    end

    @hash[:kieli] = product && values['kieli'].blank? ? @product.company.kieli : language

    keyword.attributes = values
    keyword.save
  end

  def values
    hash = @hash
    hash.each { |k, v| hash[k] = '' if hash[k].nil? }
    hash
  end

  def add_or_modify?
    %w(
      muokkaa/lisää
      muokkaa/lisÄÄ
      muokkaa/lisäÄ
      muokkaa/lisÄä
      muokkaa/lisaa
    ).include? @toiminto.to_s.downcase
  end

  def add_new?
    %w(lisää lisÄÄ lisäÄ lisÄä lisaa).include? @toiminto.to_s.downcase
  end

  def modify_row?
    %w(muokkaa muuta).include? @toiminto.to_s.downcase
  end

  def remove_row?
    %w(poista).include? @toiminto.to_s.downcase
  end
end
