class Import::CustomerSales
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
        response.add_headers names: excel_row.values
        first_row = false
        next
      end

      row = Row.new excel_row

      number = row.product_or_customer_number
      quantity = row.values['kpl']

      number = Integer(number) rescue next

      if quantity.present?
        row.set_asiakasnro(number)
      else
        row.set_product(number)
      end

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

class Import::CustomerSales::Row
  def initialize(hash)
    @hash     = hash.dup
  end

  def product
    return unless @tuoteno.present?

    @product ||= Product.find_by tuoteno: @tuoteno
  end

  def product_raw
    @tuoteno
  end

  def set_product(tuoteno)
    @tuoteno = tuoteno
  end

  def customer
    return unless @asiakasnro.present?

    @customer ||= Customer.find_by asiakasnro: @asiakasnro
  end

  def customer_raw
    @asiakasnro
  end

  def set_asiakasnro(asiakasnro)
    @asiakasnro = asiakasnro
  end

  def price
    values['myynti eur']
  end

  def product_or_customer_number
    values['tuote/asiakas'].split(' ').first
  end

  def values
    hash = @hash
    hash.each { |k, v| hash[k] = '' if hash[k].nil? }
    hash
  end
end
