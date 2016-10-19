class Woo::Products < Woo::Base
  def self.update
    #
  end

  def update
    # @woocommerce.put("products/321", {stock_quantity: 99}).parsed_response
    p @woocommerce
  end
end
