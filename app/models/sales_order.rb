class SalesOrder < ActiveRecord::Base

  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio

  has_one :terms_of_payment, foreign_key: :tunnus, primary_key: :maksuehto

  scope :not_delivered, -> { where(tila: 'L', alatila: %w(A C)) }
  scope :not_finished, -> { where(tila: 'N') }

  self.table_name = "lasku"
  self.primary_key = "tunnus"
  self.record_timestamps = false

end
