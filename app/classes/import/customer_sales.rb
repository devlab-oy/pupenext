class Import::CustomerSales
  include Import::Base

  def initialize(company_id:, user_id:, filename:, month:, year:)
    Current.company = Company.find company_id
    Current.user = User.find user_id

    @file = setup_file filename
    @end_of_month = Date.new(year.to_i, month.to_i, 1).end_of_month
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

      errors = []

      if row.customer.present?
        header = row.customer.sales_details.create tapvm: @end_of_month, nimi: 'kissa'
        errors += header.errors.full_messages
      elsif header && row.product
        params = {
          tuoteno: row.product,
          varattu: row.quantity,
          hinta: row.price,
          laskutettuaika: @end_of_month,
          laskutettu: Current.user.kuka,
        }

        row = header.rows.create params
        errors += row.errors.full_messages
      else
        errors += row.errors
      end

      response.add_row columns: excel_row.values, errors: errors.compact
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
    @hash  = hash.dup
    @tuoteno = nil
    @asiakasnro = nil
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

  def customer
    return unless customer_raw.present?

    @customer ||= Customer.find_by asiakasnro: customer_raw
  end

  def customer_raw
    @asiakasnro
  end

  def errors
    return [] if @identifier == 'Yhteensä'
    error = []
    error << I18n.t('errors.import.product_not_found', product: product_raw) if product_raw.present? && product.nil?
    error << I18n.t('errors.import.customer_not_found', customer: customer_raw) if customer_raw.present? && customer.nil?
    error
  end

  def quantity
    values['kpl']
  end

  def price
    values['myynti eur']
  end

  def identifier_column
    values['asiakas/tuote']
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
      else
        @asiakasnro = @identifier
      end
    end
end
