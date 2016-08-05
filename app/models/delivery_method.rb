class DeliveryMethod < BaseModel
  include UserDefinedValidations

  validates :selite, presence: true, uniqueness: { scope: [:yhtio] }

  with_options foreign_key: :toimitustapa, primary_key: :selite do |o|
    o.has_many :customers
    o.has_many :sales_orders, class_name: 'SalesOrder::Order'
  end

  self.table_name = :toimitustapa
  self.primary_key = :tunnus
end
