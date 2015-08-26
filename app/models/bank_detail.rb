class BankDetail < BaseModel
  validates :nimitys, presence: true

  enum viite: {
    finnish: '',
    swedish: 'SE'
  }

  self.table_name = :pankkiyhteystiedot
  self.primary_key = :tunnus
end
