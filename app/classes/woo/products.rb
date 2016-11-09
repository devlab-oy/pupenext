class Woo::Products < Woo::Base

  # 1. adds products to webstore
  # 2. update stock of products in webstore

  # Create products to woocommerce
  def create
    created_count = 0
    get_products.each do |product|
      if find_by_sku(product.tuoteno).present?
        puts "Tuote #{product.tuoteno} on jo verkkokaupassa"
      else
        response = @woocommerce.post("products", product_data(product)).parsed_response
        if response["id"]
          created_count += 1
          puts "Tuote #{product.tuoteno} #{product.nimitys} lisätty verkkokauppaan"
        else
          # log errors
          puts response["message"]
        end
      end

    end

    puts "Lisättiin #{created_count} tuotetta verkkokauppaan"
  end

  # Update product
  def update
    # Find products where stock has changed, or update all?
    get_products.each do |product|
      if find_by_sku(product.tuoteno).present?
        data = {stock_quantity: product.stock_available.to_s}
        product_id = find_by_sku(product.tuoteno)["id"]
        @woocommerce.put("products/#{product_id}", data).parsed_response
      else
        puts "Tuotetta #{product.tuoteno} ei ole verkkokaupassa, joten saldoa ei päivitetä"
      end
    end
  end

  def get_products
    Product.where(hinnastoon: 'e')
  end

  def product_data(product)
    {
      name: product.nimitys,
      slug: product.tuoteno,
      sku: product.tuoteno,
      type: 'simple',
      description: product.kuvaus,
      short_description: product.lyhytkuvaus,
      regular_price: product.myyntihinta.to_s,
      manage_stock: true,
      stock_quantity: product.stock_available.to_s,
      status: 'pending'
    }
  end

  def find_by_sku(sku)
    @woocommerce.get("products", {sku: sku}).parsed_response.first
  end
end
