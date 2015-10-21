class Attachment < BaseModel
  self.table_name  = :liitetiedostot
  self.primary_key = :tunnus

  belongs_to :product, foreign_key: :liitostunnus
end
