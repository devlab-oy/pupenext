class Reports::CustomerPriceListProduct
  def initialize(product:, customer: nil, customer_subcategory: nil)
    raise ArgumentError unless customer || customer_subcategory

    @product              = product
    @customer             = customer
    @customer_subcategory = customer_subcategory
  end

  def price
    if @customer
      @product.customer_price_with_info(@customer.id)
    else
      @product.customer_subcategory_price_with_info(@customer_subcategory.selite)
    end
  end

  def method_missing(method_name, *arguments, &block)
    @product.send(method_name, *arguments, &block)
  end

  def contract_price
    price[:contract_price] ? I18n.t('simple_form.yes') : I18n.t('simple_form.no')
  end
end
