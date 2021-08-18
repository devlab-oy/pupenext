class Woo::ProductsB2C < Woo::Base
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

      create_product(product)
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
  
    grouped_variants.each do |code, variants|
     
      #create the main product
      if get_sku(code)
        logger.info "Tuote #{code} on jo verkkokaupassa"
        next
      end
        response = create_product(variants.first)
        logger.info "Response #{response}"
        variantpath = "products/#{response['id']}/variations/batch"
        logger.info "Variantpath: #{variantpath}"
        #create the variants
        variants_data = {create: []}
        variants.each do |variant|
          logger.info "Variant: #{variant}"
          variants_data[:create].append(create_variant_hash(variant))
        end
        logger.info"Variants batch data: #{variants_data}"
        variant_response = woo_post(variantpath, variants_data)
        logger.info "Response to variations creation #{variant_response.to_s}"
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
      Product.where(status: %w(A P)).where(hinnastoon: 'W').where.not(keywords: Product::Keyword.where(laji: 'parametri_variaatio')).where('muutospvm > ?', 1.week.ago)
    end

    def variant_products
      # Näkyviin tuotteet A ja P statuksella, mutta vain ne tuotteet joissa Hinnastoon valinnoissa
      # verkkokauppa näkyvyys päällä on variantteja
      variants = Product.where(status: %w(A P)).where(hinnastoon: 'W').where(keywords: Product::Keyword.where(laji: 'parametri_variaatio')).where('muutospvm > ?', 1.week.ago)
    end

    def product_hash(product)
      #get the images of the product
      images = []
      product_images = product.attachments.where(kayttotarkoitus: "TK")
      unless product_images.empty?
      	product_images.each do |image|
          image_hash = {src: "https://kuvamakia.devlab.fi/view.php?id="+image.tunnus.to_s}.compact.to_h
          images.append(image_hash)
        end
      end
      
      if product.keywords.where(laji: 'parametri_variaatio').exists?
        type = "variable"
        sku = product.keywords.where(laji: 'parametri_variaatio').first["selite"]
        logger.info "SKU: #{sku}"
        
        #colors = get_all_colors(product.keywords.where(laji: 'parametri_variaatio').first["selite"])
        #logger.info "Colors! #{colors}"
        sizes = get_all_sizes(product.keywords.where(laji: 'parametri_variaatio').first["selite"])
        logger.info "Sizes! #{sizes}"

        #create the attributes
        attribs = [{
      	id: get_size_id(),
        position: 0,
        visible: true, 
        variation: true,
        options: sizes
        },
        #{
        #id: get_colour_id(),
        #position: 0,
        #visible: true,
        #variation: true,
        #options: colors
        #}
        ]

      else 
        type = "simple"
        sku = product.tuoteno
        attribs = []
        meta_data = []
      end 
      
      defaults = {
        name: product.nimitys,
        slug: sku,
        sku: sku,
        type: type,
        description: product.mainosteksti,
        short_description: product.kuvaus,
        regular_price: product.myymalahinta.to_s,
        tax_class: "alv-24",
        manage_stock: false,
        stock_quantity: product.stock_available.to_s,
        status: 'pending',
      }
      meta_data = [
        {"key": "_delivery_window", "value": product.osasto.to_s},
        {"key": "_product_color", "value": product.keywords.where(laji: "parametri_vari").pluck(:selite).first},
        {"key": "_product_material", "value": product.lyhytkuvaus},
      ]
      logger.info "Meta: #{meta_data}"

      unless meta_data.empty?
        defaults.merge!({meta_data: meta_data})
      end
      #unless images.empty?
      #   defaults.merge!({ images: images})
      #end

      unless attribs.empty?
         defaults.merge!({ attributes: attribs })
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
        sku: product.tuoteno,
        regular_price: product.myymalahinta.to_s,
        tax_class: "alv-24",
        manage_stock: true,
        stockstatus: "instock",
        attributes: [
        {
          id: get_size_id(),
          option: product.keywords.where(laji: "parametri_koko").pluck(:selite).to_s
        },
        #{
        #  id: get_colour_id(),
        #  option: "Blue"
        #}
        ],
        #meta_data: [{"_delivery_window": product.osasto.to_s}]
      }
      return defaults
    
    end

    def get_colour_id()
      response = woo_get("products/attributes")
      logger.info "Attributes #{response}"
      response.each do |attrib|
	      if attrib["slug"] == "pa_color"
          return attrib["id"]
        end
      end
    end

    def get_size_id()
      response = woo_get("products/attributes")
      logger.info "Attributes #{response}"
      response.each do |attrib|
        if attrib["slug"] == "pa_size"
         return attrib["id"]
        end
      end
    end

    def get_all_colors(variant_group_id)
       variants = Product::Keyword.where(laji: "parametri_variaatio").where(selite: variant_group_id).pluck("tuoteno")
       #logger.info "Variants? #{variants}"
       Product::Keyword.where(laji: "parametri_vari").where(tuoteno: variants).pluck(:selite)
    end

    def get_all_sizes(variant_group_id)
       variants = Product::Keyword.where(laji: "parametri_variaatio").where(selite: variant_group_id).pluck("tuoteno")
       logger.info "Variants? #{variants}"
       Product::Keyword.where(laji: "parametri_koko").where(tuoteno: variants).pluck(:selite)
    end

    def get_sku(sku)
      response = woo_get('products', sku: sku)
      product = response.try(:first)

      return if product.nil? || product['id'].blank?

      response.first
    end

    def create_product(product)
      response = woo_post('products', product_hash(product))
      logger.info "Tuote #{product.tuoteno} #{product.nimitys} lisätty verkkokauppaan"
      return response
    end

    def update_stock(id, product)
      data = { stock_quantity: product.stock_available.to_s }
      response = woo_put("products/#{id}", data)

      return 0 unless response

      logger.info "Tuotteen #{product.tuoteno} #{product.nimitys} saldo #{product.stock_available}"
      1
    end
end
