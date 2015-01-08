class Accounting::Attachment < ActiveRecord::Base

  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio
  belongs_to :voucher, foreign_key: :tunnus, primary_key: :liitostunnus

  # Map old database schema table to Accounting::Attachment class
  self.table_name  = :liitetiedostot
  self.primary_key = :tunnus

end
