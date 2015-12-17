class DeliveryMethod < BaseModel
  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio
  has_many :customers, foreign_key: :toimitustapa, primary_key: :selite

  self.table_name = :toimitustapa
  self.primary_key = :tunnus
end
