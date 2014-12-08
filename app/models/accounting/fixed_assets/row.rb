class Accounting::FixedAssets::Row < ActiveRecord::Base

  has_one :company, foreign_key: :yhtio, primary_key: :yhtio
  has_one :commodity, foreign_key: :tunnus, primary_key: :liitostunnus

  # Map old database schema table to Accounting::FixedAssets::Row class
  self.table_name = :kayttomaisuus_poistoera
  self.primary_key = :tunnus

  default_scope { order(tapvm: :asc) }
end
