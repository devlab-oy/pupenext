class Parameter < BaseModel
  self.table_name = :yhtion_parametrit
  self.primary_key = :tunnus

  enum kerayserat: {
    collection_batch_not_in_use: '',
    collection_batch_based_on_dimensions: 'K',
    collection_batch_based_on_weight: 'P',
    collection_batch_based_on_weight_if_customer_permit:  'A'
  }

  enum saldo_kasittely: {
    default_stock_management: '',
    stock_management_by_pick_date: 'T',
    stock_management_by_pick_date_and_with_future_reservations: 'U',
  }
end
