class Woo::Products < Woo::Base
  # 1. adds products to webstore
  # 2. update stock of products in webstore

  # Create products to woocommerce
  def create
    created_count = 0

    products.each do |product|
      if get_sku(product.tuoteno).present?
        logger.info "Tuote #{product.tuoteno} on jo verkkokaupassa"
      else
        response = @woocommerce.post('products', product_hash(product)).parsed_response

        if response['id']
          created_count += 1
          logger.info "Tuote #{product.tuoteno} #{product.nimitys} lisätty verkkokauppaan"
        else
          # log errors
          logger.error response['message']
        end
      end
    end

    logger.info "Lisättiin #{created_count} tuotetta verkkokauppaan"
  end

  # Update product stock quantity
  def update
    updated_count = 0

    # Find products where stock has changed, or update all?
    products.each do |product|
      woo_product = get_sku(product.tuoteno)

      if woo_product.present?
        data = { stock_quantity: product.stock_available.to_s }

        @woocommerce.put("products/#{woo_product['id']}", data).parsed_response

        updated_count += 1
        logger.info "Tuoteen #{product.tuoteno} #{product.nimitys} saldo päivitetty"
      else
        logger.info "Tuotetta #{product.tuoteno} ei ole verkkokaupassa, joten saldoa ei päivitetty"
      end
    end

    logger.info "Päivitettiin #{updated_count} tuotteen saldot"
  end

  def products
    # Näkyviin tuotteet A ja P statuksella, mutta vain ne tuotteet joissa Hinnastoon valinnoissa
    # verkkokauppa näkyvyys päällä
    Product.where(status: %w(A P)).where(hinnastoon: 'W')
  end

  def product_hash(product)
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
      status: 'pending',
    }
  end

  def get_sku(sku)
    @woocommerce.get('products', sku: sku).parsed_response.first
  end
end
