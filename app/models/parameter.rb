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
end
