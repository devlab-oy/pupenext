class DeliveryMethod < BaseModel
  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio

  self.table_name = :toimitustapa
  self.primary_key = :tunnus

end
