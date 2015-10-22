class Head::SalesInvoiceExtra < Head
  belongs_to :invoice, foreign_key: :otunnus, class_name: 'Head::SalesInvoice'
  belongs_to :order, foreign_key: :otunnus, class_name: 'SalesOrder::Order'
  has_one :technical_contact, foreign_key: :tunnus, primary_key: :yhteyshenkilo_tekninen, class_name: 'ContactPerson'
  has_one :commercial_contact, foreign_key: :tunnus, primary_key: :yhteyshenkilo_kaupallinen, class_name: 'ContactPerson'

  self.table_name = :laskun_lisatiedot
  self.primary_key = :tunnus
end
