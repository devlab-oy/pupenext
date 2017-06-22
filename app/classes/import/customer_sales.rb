class Import::CustomerSales
  include Import::Base

  def initialize(company_id:, user_id:, filename:, month:, year:, product:, customer_number:, customer_category:)
    Current.company = Company.find company_id
    Current.user = User.find user_id

    @file = setup_file filename
    @end_of_month = Date.new(year.to_i, month.to_i, 1).end_of_month
    @product = product
    @customer_number = customer_number
    @customer_category = customer_category
  end

  def import
    first_row = true
    header = nil
    active_customer = ''
    raw_customer = nil

    spreadsheet.each do |spreadsheet_row|
      # create hash of the row (defined in Import::Base)
      excel_row = row_to_hash spreadsheet_row

      if first_row
        response.add_headers names: excel_row.values
        first_row = false
        next
      end

      excel_row[:product] = @product
      excel_row[:customer_number] = @customer_number
      excel_row[:customer_category] = @customer_category

      row = Row.new(excel_row)

      errors = []

      if row.customer.present?
        header = row.customer.sales_details.create tapvm: @end_of_month
        errors += header.errors.full_messages
        active_customer = row.customer.asiakasnro
        raw_customer = row.data
      elsif header && row.product
        params = {
          tuoteno: row.product.tuoteno,
          kpl: row.quantity,
          hinta: row.quantity.zero? ? 0 : row.price / row.quantity,
          rivihinta: row.price,
          laskutettuaika: @end_of_month,
          laskutettu: Current.user.kuka,
        }

        row = header.rows.create params
        errors += row.errors.full_messages

        addtoresponse(row, excel_row, errors, active_customer, raw_customer)
      else
        errors += row.errors
        header = nil

        addtoresponse(row, excel_row, errors, active_customer, raw_customer)
      end
    end

    response
  end

  private

    def addtoresponse(row, excel_row, errors, active_customer, raw_customer)
      if row.product.tuoteno == @product || active_customer == @customer_number || errors.present?

        if row.product.tuoteno == @product
          errors += ["Kirjattu #{@product} tuotteelle. "]
        end

        if active_customer == @customer_number
          errors += ["Kirjattu #{@customer_number} asiakkaalle. "]
        end

        # remove default product & customer number & customer_category from response
        excel_row.delete :product
        excel_row.delete :customer_number
        excel_row.delete :customer_category

        excel_row['asiakas/tuote'].prepend("#{raw_customer}, ") if raw_customer

        response.add_row columns: excel_row.values, errors: errors.compact
      end
    end

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

    @product ||= Product.find_by(tuoteno: product_raw) || default_product
  end

  def customer
    return unless customer_raw.present?

    if chosen_customer_category.present?
      cust = Customer.find_by(asiakasnro: customer_raw, category: chosen_customer_category)
    else
      cust = Customer.find_by(asiakasnro: customer_raw)
    end

    @customer ||= cust || default_customer
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

    def chosen_customer_category
      return values[:customer_category]
    end

    def default_product
      return unless values[:product].present?

      Product.find_by tuoteno: values[:product]
    end

    def customer_raw
      identifier if quantity.blank? && identifier != 'Yhteensä'
    end

    def default_customer
      return unless values[:customer_number].present?

      Customer.find_by asiakasnro: values[:customer_number]
    end

    def required_fields
      [
        'kpl',
        'myynti eur',
        'asiakas/tuote',
      ]
    end
end
