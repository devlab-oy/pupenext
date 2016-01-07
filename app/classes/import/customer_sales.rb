class Import::CustomerSales
  include Import::Base

  def initialize(company_id:, user_id:, filename:)
    Current.company = Company.find company_id
    Current.user = User.find user_id

    @file = setup_file filename
  end

  def import
    first_row = true
    header = nil

    spreadsheet.each do |spreadsheet_row|

      # create hash of the row (defined in Import::Base)
      excel_row = row_to_hash spreadsheet_row

      if first_row
        response.add_headers names: excel_row.values
        first_row = false
        next
      end

      row = Row.new excel_row

      next if row.identifier_column == 'Yhteensä'

      errors = []

      if row.product_raw.present? && row.product.nil?
        errors << I18n.t('errors.import.product_not_found', product: row.product_raw)
      elsif row.customer_raw.present? && row.customer.nil?
        errors << I18n.t('errors.import.customer_not_found', customer: row.customer_raw)
      # elsif !row.create
      #   errors << row.keyword.errors.full_messages
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

class Import::CustomerSales::Header

  def initialize(asiakasnro)
    @asiakasnro = asiakasnro
  end

  def customer
    return unless customer_raw.present?

    @customer ||= Customer.find_by asiakasnro: customer_raw
  end

  def customer_raw
    @asiakasnro
  end
end

class Import::CustomerSales::Row
  def initialize(hash)
    @hash  = hash.dup
    @tuoteno = nil
    @identifier = nil
    set_identifier
  end

  def product
    return unless product_raw.present?

    @product ||= Product.find_by tuoteno: product_raw
  end

  def product_raw
    @tuoteno
  end

  def identifier
    @identifier
  end

  def quantity
    values['kpl']
  end

  def price
    values['myynti eur']
  end

  def identifier_column
    values['tuote/asiakas']
  end

  def values
    hash = @hash
    hash.each { |k, v| hash[k] = '' if hash[k].nil? }
    hash
  end

  private

    def parse_identifier
      identifier_column.split(' ').first
    end

    def set_identifier
      @identifier = parse_identifier

      if quantity.present?
        @tuoteno = @identifier
      end
    end
end
