class Reports::CustomerPriceList
  attr_accessor :products, :lyhytkuvaus, :kuvaus, :date_start, :date_end

  def initialize(products:, customer: nil, customer_subcategory: nil, lyhytkuvaus: false,
                 kuvaus: false, date_start: nil, date_end: nil)
    @products             = []
    @customer             = customer
    @customer_subcategory = customer_subcategory
    @lyhytkuvaus          = lyhytkuvaus
    @kuvaus               = kuvaus
    @date_start           = date_start
    @date_end             = date_end

    products.each do |product|
      @products << Reports::CustomerPriceListProduct.new(
        product: product,
        customer: customer,
        customer_subcategory: customer_subcategory
      )
    end
  end
end
