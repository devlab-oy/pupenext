class Directdebit < BaseModel
  include UserDefinedValidations

  self.table_name = :directdebit
  self.primary_key = :tunnus
  self.record_timestamps = false

  has_many :terms_of_payments
end
