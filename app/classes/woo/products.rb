require 'csv'

class Woo::Products < Woo::Base
  # 1. adds products to webstore
  # 2. update stock of products in webstore

  def check_woo

    simpl_products = Product.where(status: %w(A)).where(hinnastoon: 'W').where.not(keywords: Product::Keyword.where(laji: 'parametri_variaatio')) #.where('muutospvm > ?', 5.day.ago)
    variable_products = Product.where(status: %w(A)).where(hinnastoon: 'W').where(keywords: Product::Keyword.where(laji: 'parametri_variaatio')) #.where('muutospvm > ?', 5.day.ago)

    simpl_products.each do |product|
      if get_sku(product.tuoteno)
        next
      else
        logger.info "#{product.tuoteno} #{product.nimitys} #{product.muutospvm}"
      end
    end
    variable_products.each do |product|
      if get_sku(product.tuoteno)
        next
      else
	logger.info "#{product.tuoteno} #{product.nimitys} #{product.muutospvm}"
      end
    end
  end
 

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
      
      #if product.present? 
      #if product.sales_order_rows.where("laadittu > DATE_SUB(NOW(),INTERVAL 1 DAY)").present? or product.purchase_order_rows.where("laadittu > DATE_SUB(NOW(),INTERVAL 1 DAY)").present? or product.shelf_locations.where("saldoaika > DATE_SUB(NOW(),INTERVAL 1 DAY)").present? or product.shelf_locations.where("inventointiaika > DATE_SUB(NOW(),INTERVAL 1 DAY)").present?
      if product.sales_order_rows.where("laadittu > ?", 2.hours.ago).present? or product.purchase_order_rows.where("laadittu > ?", 2.hours.ago).present? or product.shelf_locations.where("inventointiaika > ?", 2.hours.ago).present? or product.shelf_locations.where("saldoaika > ?", 2.hours.ago).present?
      begin
      woo_product = get_sku(product.tuoteno)
      rescue;end
      unless woo_product
        logger.info "Tuotetta #{product.tuoteno} ei ole verkkokaupassa, joten dataa ei päivitetty"

        next
      end

      updated_count += update_stock(woo_product['id'], product)
      end
    end

    variant_products.each do |product|
      #if product.present?
      #if product.sales_order_rows.where("laadittu > DATE_SUB(NOW(),INTERVAL 1 DAY)").present? or product.purchase_order_rows.where("laadittu > DATE_SUB(NOW(),INTERVAL 1 DAY)").present? or product.shelf_locations.where("saldoaika > DATE_SUB(NOW(),INTERVAL 1 DAY)").present? or  product.shelf_locations.where("inventointiaika > DATE_SUB(NOW(),INTERVAL 1 DAY)").present? 
      if product.sales_order_rows.where("laadittu > ?", 2.hours.ago).present? or product.purchase_order_rows.where("laadittu > ?", 2.hours.ago).present? or product.shelf_locations.where("inventointiaika > ?", 2.hours.ago).present? or product.shelf_locations.where("saldoaika > ?", 2.hours.ago).present?

      begin
      woo_product = get_sku(product.tuoteno)
      rescue;end

      unless woo_product
        logger.info "Tuotetta #{product.tuoteno} ei ole verkkokaupassa, joten tietoja ei päivitetty"

        next
      end

      updated_count += update_variant_stock(woo_product['id'], woo_product['parent_id'], product)
      end
    end

    logger.info "Päivitettiin #{updated_count} tuotteen saldot"
  end

  # Update product info
  def update_info
    updated_count = 0
    logger.info "Tuotteet #{products}"
    products.each do |product|
      woo_product = get_sku(product.tuoteno)

      unless woo_product
        logger.info "Tuotetta #{product.tuoteno} ei ole verkkokaupassa, joten tietoja ei päivitetty"

        next
      end

      updated_count += update_datas(woo_product['id'], product)
    end

    variant_products.each do |product|
      woo_product = get_sku(product.tuoteno)

      unless woo_product
        logger.info "Tuotetta #{product.tuoteno} ei ole verkkokaupassa, joten tietoja ei päivitetty"

	next
      end

      updated_count += update_variant_datas(woo_product['id'], woo_product['parent_id'], product)
    end


    logger.info "Päivitettiin #{updated_count} tuotteentiedot"
  end
  
    def sku_csv
      CSV.open("/home/devlab/sku.csv", "r", { :col_sep => ";" }).each do |row|
        logger.info "#{row}"
        update_sku(row[0],row[1])
      end
    end

    def stock_csv
      CSV.open("/home/devlab/items2.csv", "r", { :col_sep => ","}).each do |row|
        logger.info "#{row}"
        if row[1] = 0
          update_manage_stock(row[0])
        end
      end
    end

    def update_manage_stock(id)
      data = {manage_stock: false}
      response = woo_put("products/#{id}", data)
      variants_response = woo_get("products/#{id}/variations")
      logger.info("#{response}")
      variants_response.each do |variant|
          v_id = variant['id']
          vdata = { manage_stock: true}
          response = woo_put("products/#{id}/variations/#{v_id}", vdata)
	  logger.info("#{response}")
      end 
    end

    def update_sku(sku,nusku)
      logger.info "#{sku} , #{nusku}"
      woo_product = get_sku(sku)
      unless woo_product
       return 0 
      end

      if woo_product['type'] == 'variable' 
        data = { sku: nusku }
        id = woo_product['id']
        variants_response = woo_get("products/#{id}/variations")
        response = woo_put("products/#{id}", data)
        logger.info("#{response}")
        response = woo_put("products/#{id}", data)
        variants_response.each do |variant|
          v_id = variant['id']
          v_sku = variant['sku']
          vdata = { sku: v_sku}
          response = woo_put("products/#{id}/variations/#{v_id}", vdata)
          logger.info("#{v_id} & #{v_sku}")
          logger.info("#{response}")
        end
      end
    end

  private

    def products
      # Näkyviin tuotteet A ja P statuksella, mutta vain ne tuotteet joissa Hinnastoon valinnoissa
      # verkkokauppa näkyvyys päällä ei variantteja
      Product.where(status: %w(A P)).where(hinnastoon: 'W').where.not(keywords: Product::Keyword.where(laji: 'parametri_variaatio')) #where('muutospvm > ?', 15.day.ago)
      #Product.where.not(keywords: Product::Keyword.where(laji: 'parametri_variaatio'))
      #Product.where(tuoteno: 19009)
    end

    def variant_products
      # Näkyviin tuotteet A ja P statuksella, mutta vain ne tuotteet joissa Hinnastoon valinnoissa
      # verkkokauppa näkyvyys päällä on variantteja
      variants = Product.where(status: %w(A P)).where(hinnastoon: 'W').where(keywords: Product::Keyword.where(laji: 'parametri_variaatio')) #where('muutospvm > ?', 15.day.ago)
      #variants = Product.where(keywords: Product::Keyword.where(laji: 'parametri_variaatio')) #where('muutospvm > ?', 1.day.ago)
      #variants = Product.where(keywords: Product::Keyword.where(laji: 'parametri_variaatio').where(selite: 'liotusallas')) 
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
        regular_price: product.myyntihinta.to_s,
        manage_stock: true,
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
        regular_price: product.myyntihinta.to_s,
        manage_stock: false,
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
      #logger.info "Response: #{response}"

      return if product.nil? || product['id'].blank?

      response.first
    end

    def create_product(product)
      response = woo_post('products', product_hash(product))
      logger.info "Tuote #{product.tuoteno} #{product.nimitys} lisätty verkkokauppaan"
      return response
    end

    def update_datas(id, product)
      data = { price: product.myymalahinta.to_s , regular_price: product.myyntihinta.to_s, weight: product.tuotemassa.to_s, manage_stock: true}
        
      meta_data = [
        {"key": "brand", "value": product.tuotemerkki}
      ]
      logger.info "Meta: #{meta_data}"

      unless meta_data.empty?
        data.merge!({meta_data: meta_data})
      end

        logger.info "Tuote #{id} datalla  #{data}"
        response = woo_put("products/#{id}", data)
        #response = woo_put("products/4646", data)
        logger.info "Response: #{response}"
        return 0 unless response
        1
    end

     def update_variant_datas(id, parent_id, product)
      data_parent = {manage_stock: false}
      data = { price: product.myymalahinta.to_s , regular_price: product.myyntihinta.to_s, weight: product.tuotemassa.to_s, manage_stock: true}
      
      meta_data_parent = [
        {"key": "brand", "value": product.tuotemerkki},
      ]

      meta_data = [
        {"key": "brand", "value": product.tuotemerkki},
        {"key": "variation_myyntinimike", "value": product.nimitys}
      ]
      logger.info "Meta: #{meta_data}"

      unless meta_data.empty?
        data.merge!({meta_data: meta_data})
        data_parent.merge!({meta_data: meta_data_parent})
      end


        logger.info "Tuote #{id} datalla  #{data}"
        response = woo_put("products/#{parent_id}", data_parent)
        logger.info "Response from parent: #{response}"
        response = woo_put("products/#{parent_id}/variations/#{id}", data)
        logger.info "Response: #{response}"
        return 0 unless response
	1
    end

    def update_variant_stock(id, parent_id, product)
      data = { stock_quantity: product.stock_available.to_s }
      begin
      response = woo_put("products/#{parent_id}/variations/#{id}", data)

      return 0 unless response
      rescue; end
      logger.info "Variaation #{product.tuoteno} #{product.nimitys} saldo #{product.stock_available}"
      1
    end

    def update_stock(id, product)
      data = { stock_quantity: product.stock_available.to_s }
      begin
      response = woo_put("products/#{id}", data)

      return 0 unless response
      rescue; end
      logger.info "Tuotteen #{product.tuoteno} #{product.nimitys} saldo #{product.stock_available}"
      1
    end
end
