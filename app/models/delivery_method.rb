class DeliveryMethod < BaseModel
  include UserDefinedValidations

  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio

  with_options foreign_key: :toimitustapa, primary_key: :selite do |o|
    o.has_many :customers
    o.has_many :sales_orders, class_name: 'SalesOrder::Order'
  end

  self.table_name = :toimitustapa
  self.primary_key = :tunnus
end
