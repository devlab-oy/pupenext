class Head::SalesInvoiceRow < BaseModel

  belongs_to :invoice, foreign_key: :uusiotunnus, class_name: 'Head::SalesInvoice'

  default_scope { where(tyyppi: 'L') }

  self.table_name = :tilausrivi
  self.primary_key = :tunnus

end
