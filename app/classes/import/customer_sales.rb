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
        header = row.customer.sales_details.create tapvm: @end_of_month
        errors += header.errors.full_messages
      elsif header && row.product
        params = {
          tuoteno: row.product.tuoteno,
          kpl: row.quantity,
          hinta: row.price / row.quantity,
          rivihinta: row.price,
          laskutettuaika: @end_of_month,
          laskutettu: Current.user.kuka,
        }

        row = header.rows.create params
        errors += row.errors.full_messages
      else
        errors += row.errors
        header = nil
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
    @hash = hash.dup
  end

  def product
    return unless product_raw.present?

    @product ||= Product.find_by tuoteno: product_raw
  end

  def customer
    return unless customer_raw.present?

    @customer ||= Customer.find_by asiakasnro: customer_raw
  end

  def errors
    error = []

    if product_raw.present? && product.nil?
      error << I18n.t('errors.import.product_not_found', product: product_raw)
    end

    if customer_raw.present? && customer.nil?
      error << I18n.t('errors.import.customer_not_found', customer: customer_raw)
    end

    if data.blank? || (quantity.blank? && price.blank?)
      error << I18n.t('errors.import.required_fields_missing', fields: required_fields.to_sentence)
    end

    error
  end

  def quantity
    values['kpl']
  end

  def price
    values['myynti eur']
  end

  def data
    values['asiakas/tuote']
  end

  private

    def values
      hash = @hash
      hash.each { |k, v| hash[k] = '' if hash[k].nil? }
      hash
    end

    def identifier
      data.to_s.split(' ').first
    end

    def product_raw
      identifier if quantity.present?
    end

    def customer_raw
      identifier if quantity.blank? && identifier != "Yhteensä"
    end

    def required_fields
      [
        'kpl',
        'myynti eur',
        'asiakas/tuote'
      ]
    end
end
