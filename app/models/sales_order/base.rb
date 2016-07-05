class SalesOrder::Base < Head
  has_many :installments, foreign_key: :otunnus
  has_many :rows, foreign_key: :otunnus, class_name: 'SalesOrder::Row'
  has_one :invoice, foreign_key: :laskunro, primary_key: :laskunro, class_name: 'Head::SalesInvoice'

  # Child class will have the STI tables
  self.abstract_class = true

  # We have actually 2 types, that are saved in "tila".
  TYPES = %w{L N}
end
