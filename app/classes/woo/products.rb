class Woo::Products < Woo::Base
  # 1. adds products to webstore
  # 2. update stock of products in webstore

  # Create products to woocommerce
  def create
    created_count = 0
    #creating the simple products
    products.each do |product|
      if get_sku(product.tuoteno)
        logger.info "Tuote #{product.tuoteno} on jo verkkokaupassa"

        next
      end

      created_count += create_product(product)
    end

    logger.info "Lisättiin #{created_count} tuotetta verkkokauppaan"

    #creating the variable products
    
	  grouped_variants = {}
    
	  #create the batches of variant products grouped together
	  variant_products.each do |product|
      variant_code = product.keywords.where(laji: 'parametri_variaatio').first
      if not grouped_variants[variant_code.selite].present?
        grouped_variants[variant_code.selite] = []
      end
      grouped_variants[variant_code.selite].append product
    end
  
    grouped_variants.each do |variant_set|
      response = woo_post('products', product_hash(product)) 
      variantpath = "products/#{response['id'].to_s}/variations/batch"
      #create the attributes
      size = get_size_id()
      colour = get_colour_id()
      attribs = []
      main_product.append(attribs)
      #create the main product
      product_id = create_product(main_product)[id]
      #create the variants
      variants_data = {create: []}
      each in variant_set do |variant|
        variants_data["create"].append(create_variant_hash(variant))
      end
      variant_response = woo_post(logpath, variant_data)
      logger.info "Response to variations #{variant_response.to_s}"

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

    def product_hash(product)
      #get the images of the product
      images = []
      product_images = product.attachments
      #where(kayttotarkoitus: "Tuotekuva")
      unless product_images.empty?
      	product_images.each do |image|
          image_hash = {src: "https://kuvamakia.devlab.fi/view.php?id="+image.tunnus.to_s}.compact.to_h
          images.append(image_hash)
        end
      end

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
      }

      unless images.empty?
         logger.info "Images #{images}"
         defaults.merge!({ images: images})
      end

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
    
    def create_variant_hash(product)

      defaults = {
        regular_price: "10.00", #product price
        attributes: [
        {
          id: 3, #size id
          option: "XL" #product keyword variantti_koko
          sku: #product_sku
        }
      ]
      }
    
    end

    def get_colour_id
      #colour id code
    end

    def get_size_id
      #size id code
    endhttps://www.instagram.com/

    def get_sku(sku)
      response = woo_get('products', sku: sku)
      product = response.try(:first)

      return if product.nil? || product['id'].blank?

      response.first
    end

    def create_product(product)
      response = woo_post('products', product_hash(product))
      logger.info "Response #{response.to_s}"
      #return 0 unless response && response['id']
      logger.info "Tuote #{product.tuoteno} #{product.nimitys} lisätty verkkokauppaan"

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
