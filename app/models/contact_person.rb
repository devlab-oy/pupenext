class ContactPerson < BaseModel

  self.table_name = :yhteyshenkilo
  self.primary_key = :tunnus

  scope :customer, -> { where(tyyppi: 'A') }
  scope :supplier, -> { where(tyyppi: 'T') }

end
