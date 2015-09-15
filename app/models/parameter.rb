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
    service_products_manual_deliverydates: 'K',
    all_products_manual_deliverydates: 'X',
  }
end
