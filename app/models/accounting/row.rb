class Accounting::Row < ActiveRecord::Base

  has_one :company, foreign_key: :yhtio, primary_key: :yhtio
  has_one :voucher, foreign_key: :tunnus, primary_key: :ltunnus

  # Map old database schema table to Accounting::Row class
  self.table_name  = :tiliointi
  self.primary_key = :tunnus

end
