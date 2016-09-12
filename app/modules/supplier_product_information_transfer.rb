module SupplierProductInformationTransfer
  def self.transfer(params, supplier:)
    transferable                  = params.select { |_k, v| v[:transfer] == '1' }
    supplier_product_informations = SupplierProductInformation.find(transferable.keys)
    supplier                      = Supplier.find(supplier)
    duplicates                    = []

    supplier_product_informations.each do |s|
      extra_attributes = transferable[s.id.to_s]

      if extra_attributes[:manufacturer_part_number].present?
        s.manufacturer_part_number = extra_attributes[:manufacturer_part_number]
      end

      if extra_attributes[:manufacturer_ean].present?
        s.manufacturer_ean = extra_attributes[:manufacturer_ean]
      end

      duplicate_tuoteno = Product.where(tuoteno: s.manufacturer_part_number)
      duplicate_ean     = Product.where(eankoodi: s.manufacturer_ean).where.not(eankoodi: '')

      if duplicate_tuoteno.any?
        s.errors.add(:manufacturer_part_number,
                     I18n.t('supplier_product_informations.transfer.duplicate_tuoteno'))
      end

      if duplicate_ean.any?
        s.errors.add(:manufacturer_ean,
                     I18n.t('supplier_product_informations.transfer.duplicate_ean'))
      end

      if s.errors.any?
        duplicates << s
        next
      end

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
        product_params[:status] = extra_attributes[:status]
      end

      if extra_attributes[:try]
        product_params[:subcategory] = Product::Subcategory.find(extra_attributes[:try])
      end

      product = s.create_product(product_params)

      supplier_product_information_params = {
        p_price_update: extra_attributes[:toimittajan_ostohinta],
        p_qty_update:   extra_attributes[:toimittajan_saldo],
        product:        product
      }

      if extra_attributes[:p_tree_id]
        dynamic_tree = Category::Product.find(extra_attributes[:p_tree_id])

        supplier_product_information_params[:product_category] = dynamic_tree

        product.product_links.create(
          category: dynamic_tree,
          kutsuja: 'SupplierProductInformationTransfer'
        )
      end

      s.update(supplier_product_information_params)

      supplier.product_suppliers.create(
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
