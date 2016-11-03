class Woo::Products < Woo::Base

  # Create all products to woocommerce
  def create
    get_products.each do |product|
      response = @woocommerce.post("products", product_data(product)).parsed_response

      if response["code"]
        # handle errors
        puts response["message"]
      else
        puts response
        # Save newly created product id to pupe
        # product.update(woocommerce_id: response["id"])
      end
    end
  end

  # Update product
  def update_stock(id, stock_quantity)
    @woocommerce.put("products/#{id}", {stock_quantity: stock_quantity}).parsed_response
  end

  def get_products
    # millä ehdolla tuotteita haetaan?
    [Product.last]
  end

  def get_new_products
    # Verkkakaupasta "puuttuvat tuotteet", eli joilla on verkkokauppanäkyvyys ja woocommerce id puuttuu
    # Product.where(nakyvyys: "", woocommerce_id: nil)
  end

  def product_data(product)
    {
      name: product.nimitys,
      slug: product.tuoteno,
      type: 'simple',
      description: product.kuvaus,
      short_description: product.lyhytkuvaus,
      regular_price: product.myyntihinta.to_s,
      manage_stock: true,
      stock_quantity: product.shelf_locations.reduce(0) {|saldo, shelf| saldo += sheld.saldo}.to_s,
      status: 'pending'
    }
  end
end
