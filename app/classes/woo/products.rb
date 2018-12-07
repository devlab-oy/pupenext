class Woo::Products < Woo::Base
  # 1. adds products to webstore
  # 2. update stock of products in webstore

  # Create products to woocommerce
  def create
    created_count = 0

    products.each do |product|
      if get_sku(product.tuoteno)
        logger.info "Tuote #{product.tuoteno} on jo verkkokaupassa"
        next
      end
      created_count += create_product(product)
    end

    logger.info "Lisättiin #{created_count} tuotetta verkkokauppaan"
  end

  #go through any products with variants and create variant sets
  def create_variants
    grouped_variants = {}
    variant_products.each do |product|
          variant_code = product.keywords.where(laji: 'parametri_variaatio').first
          if not grouped_variants[variant_code.selite].present?
            grouped_variants[variant_code.selite] = []
          end
          grouped_variants[variant_code.selite].append product
    end

    grouped_variants.each do |key,value|
      create_product_with_variants(key, value)
    end
  end

  # Update product stock quantity
  def update
    updated_count = 0

    products.each do |product|
      woo_product = get_sku(product.tuoteno)

      unless woo_product
        logger.info "Tuotetta #{product.tuoteno} ei ole verkkokaupassa, joten saldoa ei päivitetty"

        next
      end

      updated_count += update_stock(woo_product['id'], product)
    end

    logger.info "Päivitettiin #{updated_count} tuotteen saldot"
  end

  private

    def products
      # Näkyviin tuotteet A ja P statuksella, mutta vain ne tuotteet joissa Hinnastoon valinnoissa
      # verkkokauppa näkyvyys päällä ei variantteja
      Product.where(status: %w(A P)).where(hinnastoon: 'W').where.not(keywords: Product::Keyword.where(laji: 'parametri_variaatio'))
    end

    def variant_products
      # Näkyviin tuotteet A ja P statuksella, mutta vain ne tuotteet joissa Hinnastoon valinnoissa
      # verkkokauppa näkyvyys päällä on variantteja
      variants = Product.where(status: %w(A P)).where(hinnastoon: 'W').where(keywords: Product::Keyword.where(laji: 'parametri_variaatio'))
    end


    def 

    def product_hash(product)
      defaults = {
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
        #images: [product.attachments.first.tunnus],
      }

      from_keywords = Keyword::WooField.all.pluck(:selite, :selitetark).map do |selite, selitetark|
        selite = selite.to_sym

        if selitetark.blank?
          defaults.delete(selite)
          nil
        else
          [selite, product.send(selitetark)]
        end
      end.compact.to_h

      defaults.merge(from_keywords)
    end

    def variant_main_hash(product, color_id, size_id)
      defaults = {
        name: product.nimitys,
        slug: product.tuoteno,
        sku: product.tuoteno,
        type: 'variable'
        description: product.kuvaus,
        short_description: product.lyhytkuvaus
        regular_price: product.myyntihinta.to_s,
        manage_stock: true,
        stock_quantity: product.stock_available.to_s,
        status: 'pending',
        #images: [product.attachments.first.tunnus],
        attributes: [
          {
            id: color_id,
            position: 0,
            visible: false,
            variation: true,
            options: keywords.where(laji: 'parametri_vari').first
          },
          {
            id: size_id,
            position: 0,
            visible: false,
            variation: true,
            options: keywords.where(laji: 'parametri_koko').first
          },
        ]
      }

    def variant_hash(product, color_id,size_id)
      data = {
        regular_price: product.myyntihinta.to_s,
        #image: {
        #  id: FUUUUUUUUUUUUUUUUUUUUUUUUUU
        #},
        attributes: [
          {
            id: size_id,
            option: keywords.where(laji: 'parametri_koko').first
          },
          {
            id: color_id,
            option: keywords.where(laji: 'parametri_koko').first
          }
        ]
      }
      
    def get_sku(sku)
      response = woo_get('products', sku: sku)
      product = response.try(:first)

      return if product.nil? || product['id'].blank?

      response.first
    end

    def create_product(product)
      response = woo_post('products', product_hash(product))

      return 0 unless response && response['id']

      logger.info "Tuote #{product.tuoteno} #{product.nimitys} lisätty verkkokauppaan"

      1
    end

    def create_product_with_variants(product)
      
      attribs = woocommerce.get("products/attributes").parsed_response
      attribs.each do |attrib|
        if attrib['name'] == 'Color'
          color_id = attrib["id"]
        end
        if attrib['name'] == 'Size'
          size_id = attrib['id']
        end
      end

      size_list = []
      color_list = []

      #creating the main product
      response = woo_post('products', variant_main_hash(product, color_id, size_id,color_list,size_list))

      return 0 unless response && response['id']

      logger.info "Tuote #{product.tuoteno} #{product.nimitys} lisätty verkkokauppaan"

      #createing the variants to the main product
      response = woo_post('products', variant_hash())

      1
    end

    def update_stock(id, product)
      data = { stock_quantity: product.stock_available.to_s }
      response = woo_put("products/#{id}", data)

      return 0 unless response

      logger.info "Tuotteen #{product.tuoteno} #{product.nimitys} saldo #{product.stock_available}"
      1
    end
end
