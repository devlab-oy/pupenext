class Accounting::Row < ActiveRecord::Base

  has_one :company, foreign_key: :yhtio, primary_key: :yhtio
  has_one :voucher, foreign_key: :tunnus, primary_key: :ltunnus
  has_one :cost_row, class_name: 'Accounting::FixedAssets::CommodityCostRow',
    foreign_key: :tiliointirivi_tunnus

  # Map old database schema table to Accounting::Row class
  self.table_name  = :tiliointi
  self.primary_key = :tunnus

  default_scope { order(tapvm: :asc) }
  scope :active, -> { where(korjattu: '') }

end
