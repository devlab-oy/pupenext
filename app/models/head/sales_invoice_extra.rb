class Head::SalesInvoiceExtra < Head
  belongs_to :invoice, foreign_key: :tunnus, primary_key: :otunnus, class_name: 'Head::SalesInvoice'

  self.table_name = :laskun_lisatiedot
  self.primary_key = :tunnus
end
