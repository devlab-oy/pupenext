class Parameter < BaseModel
  self.table_name = :yhtion_parametrit
  self.primary_key = :tunnus

  belongs_to :freight_product, class_name: 'Product', foreign_key: :rahti_tuotenumero, primary_key: :tuoteno

  enum saldo_kasittely: {
    default_stock_management: '',
    stock_management_by_pick_date: 'T',
    stock_management_by_pick_date_and_with_future_reservations: 'U',
  }
end
