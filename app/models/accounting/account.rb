class Accounting::Account < ActiveRecord::Base

  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio
  belongs_to :commodity, foreign_key: :tilino, primary_key: :tilino

  # Fixed assets accounts
  #scope :fixed, -> { where(evl_taso: 'jotain') }

  # Map old database schema table to Accounting::Attachment class
  self.table_name  = :tili
  self.primary_key = :tunnus

end
