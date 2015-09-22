class Parameter < BaseModel
  self.table_name = :yhtion_parametrit
  self.primary_key = :tunnus

  enum verkkolasku_lah: {
    apix: 'apix',
    finvoice: 'finvoice',
    ipost: 'iPost',
    maventa: 'maventa',
    pupevoice: '',
    servinet: 'servinet',
  }

  enum tilausrivien_toimitettuaika: {
    no_manual_deliverydates: '',
    manual_deliverydates_when_product_inventory_not_managed: 'K',
    manual_deliverydates_for_all_products: 'X',
  }
end
