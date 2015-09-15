class Head::SalesInvoiceRow < BaseModel

  belongs_to :invoice, foreign_key: :uusiotunnus, class_name: 'Head::SalesInvoice'

  default_scope { where(tyyppi: 'L') }
  default_scope { where.not(var: %w(P J O S)) }

  self.table_name = :tilausrivi
  self.primary_key = :tunnus

end
