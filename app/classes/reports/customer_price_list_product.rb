class Reports::CustomerPriceListProduct
  def initialize(product:, customer: nil, customer_subcategory: nil)
    @product              = product
    @customer             = customer
    @customer_subcategory = customer_subcategory
  end

  def price
    if @customer
      @product.customer_price_with_info(@customer.id)
    else
      @product.customer_subcategory_price_with_info(@customer_subcategory)
    end
  end

  def method_missing(method_name, *arguments, &block)
    @product.send(method_name, *arguments, &block)
  end
end
