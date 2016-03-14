class Reports::CustomerPriceList
  attr_accessor :products, :lyhytkuvaus, :kuvaus

  def initialize(products:, customer: nil, customer_subcategory: nil, lyhytkuvaus: false,
                 kuvaus: false)
    @products             = []
    @customer             = customer
    @customer_subcategory = customer_subcategory
    @lyhytkuvaus          = lyhytkuvaus
    @kuvaus               = kuvaus

    products.each do |product|
      @products << Reports::CustomerPriceListProduct.new(
        product: product,
        customer: customer,
        customer_subcategory: customer_subcategory
      )
    end
  end
end
