class Parameter < BaseModel
  self.table_name = :yhtion_parametrit
  self.primary_key = :tunnus

  enum saldo_kasittely: {
    default_stock_management: '',
    stock_management_by_pick_date: 'T',
    stock_management_by_pick_date_and_with_future_reservations: 'U',
  }

  def self.freight_product
    Product.find_by!(tuoteno: first.rahti_tuotenumero)
  end
end
