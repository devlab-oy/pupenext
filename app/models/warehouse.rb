class Warehouse < BaseModel
  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio
  has_many :packing_areas, foreign_key: :varasto, primary_key: :tunnus

  # Map old database schema table to Qualifier class
  self.table_name  = :varastopaikat
  self.primary_key = :tunnus
end
