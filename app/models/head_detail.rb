class HeadDetail < BaseModel
  self.table_name  = :laskun_lisatiedot
  self.primary_key = :tunnus

  belongs_to :head, foreign_key: :otunnus
end
