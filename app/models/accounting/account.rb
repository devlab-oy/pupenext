class Accounting::Account < ActiveRecord::Base

  has_one :company, foreign_key: :yhtio, primary_key: :yhtio
  has_one :commodity, foreign_key: :tilino, primary_key: :tilino

  # Fixed assets accounts
  #scope :fixed, -> { where(kayttomaisuustili: 'x') }

  # Map old database schema table to Accounting::Attachment class
  self.table_name  = :tili
  self.primary_key = :tunnus

end
