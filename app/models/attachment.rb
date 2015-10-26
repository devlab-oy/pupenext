class Attachment < BaseModel
  include PupenextSingleTableInheritance

  validates :data, presence: true

  self.table_name         = :liitetiedostot
  self.primary_key        = :tunnus
  self.inheritance_column = :liitos

  belongs_to :product, foreign_key: :liitostunnus
end
