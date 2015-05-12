class BankDetail < BaseModel
  validates :nimitys, presence: true
  validates :viite, inclusion: { in: %w(SE) }, allow_blank: true

  self.table_name = :pankkiyhteystiedot
  self.primary_key = :tunnus
  self.record_timestamps = false
end
