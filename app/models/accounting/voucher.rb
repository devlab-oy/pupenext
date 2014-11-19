class Accounting::Voucher < ActiveRecord::Base

  has_one :company, foreign_key: :yhtio, primary_key: :yhtio
  has_many :rows, foreign_key: :ltunnus, primary_key: :tunnus
  has_many :attachments, foreign_key: :liitostunnus, primary_key: :tunnus

  default_scope { where(tila: 'X') }

  # Map old database schema table to Accounting::Voucher class
  self.table_name  = :lasku
  self.primary_key = :tunnus

end
