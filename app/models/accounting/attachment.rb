class Accounting::Attachment < ActiveRecord::Base

  has_one :company, foreign_key: :yhtio, primary_key: :yhtio
  has_one :voucher, foreign_key: :tunnus, primary_key: :liitostunnus

  # Map old database schema table to Accounting::Attachment class
  self.table_name  = :liitetiedostot
  self.primary_key = :tunnus

end
