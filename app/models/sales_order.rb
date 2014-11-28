class SalesOrder < ActiveRecord::Base

  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio
  belongs_to :terms_of_payment, foreign_key: :maksuehto, primary_key: :tunnus

  scope :not_delivered, -> { where(tila: 'L', alatila: %w(A C)) }
  scope :not_finished, -> { where(tila: 'N') }

  self.table_name = "lasku"
  self.primary_key = "tunnus"
  self.record_timestamps = false

end
