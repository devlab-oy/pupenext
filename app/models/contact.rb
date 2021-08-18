class Contact < BaseModel
  include PupenextSingleTableInheritance

  self.table_name = :yhteyshenkilo
  self.primary_key = :tunnus
  
  belongs_to :customer, foreign_key: :liitostunnus
end