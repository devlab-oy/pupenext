class Warehouse < BaseModel
  include UserDefinedValidations

  has_many :packing_areas, foreign_key: :varasto
  has_many :shelf_locations, foreign_key: :varasto

  scope :active, -> { where.not(tyyppi: 'P') }

  self.table_name  = :varastopaikat
  self.primary_key = :tunnus
end
