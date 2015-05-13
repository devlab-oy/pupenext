class BankDetail < BaseModel
  self.table_name = :pankkiyhteystiedot
  self.primary_key = :tunnus
  self.record_timestamps = false
end
