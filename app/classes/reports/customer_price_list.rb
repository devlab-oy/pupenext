class Reports::CustomerPriceList
  attr_accessor :products, :customer, :customer_subcategory, :lyhytkuvaus, :kuvaus, :date_start,
                :date_end

  def initialize(products:, customer: nil, customer_subcategory: nil, lyhytkuvaus: false,
                 kuvaus: false, date_start: nil, date_end: nil)
    raise ArgumentError unless products.present?

    @products             = []
    @customer             = customer
    @customer_subcategory = customer_subcategory
    @lyhytkuvaus          = lyhytkuvaus
    @kuvaus               = kuvaus
    @date_start           = parse_date(date_start)
    @date_end             = parse_date(date_end)

    products.each do |product|
      @products << Reports::CustomerPriceListProduct.new(
        product: product,
        customer: customer,
        customer_subcategory: customer_subcategory
      )
    end
  end

  def validity
    if @date_start && @date_end
      "#{I18n.l @date_start} - #{I18n.l @date_end}"
    else
      I18n.t('reports.customer_price_lists.report.indefinitely')
    end
  end

  def self.message
    Keyword::CustomerPriceListAttribute.message
  end

  private

    def parse_date(value)
      return unless value.present?

      value.acts_like?(:date) ? value : Date.parse(value)
    end
end
