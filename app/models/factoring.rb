class Factoring < BaseModel
  self.table_name = :factoring
  self.primary_key = :tunnus
  self.record_timestamps = false

  has_many :terms_of_payments
end
