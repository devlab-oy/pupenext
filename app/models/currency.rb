class Currency < ActiveRecord::Base

  validates :nimi, presence: true

  self.table_name = "valuu"
  self.primary_key = "tunnus"
  self.record_timestamps = false

end
