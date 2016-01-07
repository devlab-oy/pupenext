class SupplierProductInformationTransfer
  def initialize(params, supplier:)
    @transferable                  = params.select { |_k, v| v[:transfer] == '1' }
    @supplier_product_informations = SupplierProductInformation.find(@transferable.keys)
    @supplier                      = Supplier.find(supplier)
  end

  def transfer
    duplicates = []

    @supplier_product_informations.each do |s|
      duplicate_products = Product.where('tuoteno = ? OR eankoodi = ?',
                                         s.manufacturer_part_number,
                                         s.manufacturer_ean)
      if duplicate_products.present?
        duplicates << s
        next
      end

      extra_attributes = @transferable[s.id.to_s]

      product_params = {
        alv:      24,
        eankoodi: s.manufacturer_ean,
        nimitys:  s.product_name,
        tuoteno:  s.manufacturer_part_number
      }

      if extra_attributes[:tuotemerkki]
        product_params[:brand] = Product::Brand.find(extra_attributes[:tuotemerkki])
      end

      if extra_attributes[:osasto]
        product_params[:category] = Product::Category.find(extra_attributes[:osasto])
      end

      if extra_attributes[:nakyvyys]
        product_params[:nakyvyys] = extra_attributes[:nakyvyys]
      end

      if extra_attributes[:status]
        product_params[:status] = Product::Status.find(extra_attributes[:status])
      end

      if extra_attributes[:try]
        product_params[:subcategory] = Product::Subcategory.find(extra_attributes[:try])
      end

      product = s.create_product(product_params)

      s.update(p_price_update: extra_attributes[:toimittajan_ostohinta],
               p_qty_update:   extra_attributes[:toimittajan_saldo],
               product:        product)

      @supplier.product_suppliers.create(
        tehdas_saldo:            s.available_quantity,
        tehdas_saldo_paivitetty: Time.now,
        toim_nimitys:            s.product_name,
        toim_tuoteno:            s.product_id,
        tuoteno:                 s.manufacturer_part_number
      )
    end

    duplicates
  end
end
