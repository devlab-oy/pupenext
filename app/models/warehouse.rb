class Warehouse < BaseModel
  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio
  has_many :packing_areas, foreign_key: :varasto, primary_key: :tunnus

  scope :active, -> { where.not(tyyppi: 'P') }

  self.table_name  = :varastopaikat
  self.primary_key = :tunnus
end
