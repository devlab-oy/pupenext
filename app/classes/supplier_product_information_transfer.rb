class SupplierProductInformationTransfer
  def initialize(params, supplier:)
    @transferable                  = params.select { |_k, v| v[:transfer] == '1' }
    @supplier_product_informations = SupplierProductInformation.find(@transferable.keys)
    @supplier                      = Supplier.find(supplier)
  end

  def transfer
    duplicates = []

    @supplier_product_informations.each do |s|
      extra_attributes = @transferable[s.id.to_s]

      manufacturer_part_number = if extra_attributes[:manufacturer_part_number].present?
                                   extra_attributes[:manufacturer_part_number]
                                 else
                                   s.manufacturer_part_number
                                 end

      manufacturer_ean = if extra_attributes[:manufacturer_ean].present?
                                   extra_attributes[:manufacturer_ean]
                                 else
                                   s.manufacturer_ean
                                 end

      duplicate_tuoteno = Product.where(tuoteno: manufacturer_part_number)
      duplicate_ean     = Product.where(eankoodi: manufacturer_ean)

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
        eankoodi: manufacturer_ean,
        nimitys:  s.product_name,
        tuoteno:  manufacturer_part_number
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
        tuoteno:                 manufacturer_part_number
      )
    end

    duplicates
  end
end
