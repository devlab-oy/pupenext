class TermsOfPayment < ActiveRecord::Base

  validates :teksti, presence: true

  self.table_name = "maksuehto"
  self.primary_key = "tunnus"
  self.record_timestamps = true

end
