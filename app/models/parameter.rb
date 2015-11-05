class Parameter < BaseModel
  self.table_name = :yhtion_parametrit
  self.primary_key = :tunnus

  enum kerayserat: {
    collection_batch_not_in_use: '',
    collection_batch_based_on_dimensions: 'K',
    collection_batch_based_on_weight: 'P',
    collection_batch_based_on_weight_if_customer_permit:  'A'
  }
end
