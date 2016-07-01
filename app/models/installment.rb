class Installment < BaseModel
  belongs_to :parent_order, foreign_key: :otunnus, class_name: 'SalesOrder::Order'
  has_one :sales_order, primary_key: :uusiotunnus, foreign_key: :tunnus, class_name: 'SalesOrder::Order'

  self.table_name = :maksupositio
  self.primary_key = :tunnus
  self.record_timestamps = false
end
