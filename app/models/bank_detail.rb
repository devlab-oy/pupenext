class BankDetail < BaseModel
  validates :nimitys, presence: true

  self.table_name = :pankkiyhteystiedot
  self.primary_key = :tunnus
  self.record_timestamps = false
end
