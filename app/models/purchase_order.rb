class PurchaseOrder < ActiveRecord::Base

  has_one :company, foreign_key: :yhtio, primary_key: :yhtio
  has_one :accounting_fixed_assets_commodity, class_name: 'Accounting::FixedAssets::Commodity',
    foreign_key: :tunnus, primary_key: :hyodyke_tunnus

  # Only paid purchase orders for now
  default_scope { where("tila in('H','Y','M','P','Q') and mapvm > 0") }
  #scope :paid, -> { where("tila in('H','Y','M','P','Q') and mapvm > 0") }

  # Map old database schema table to Accounting::Attachment class
  self.table_name  = :lasku
  self.primary_key = :tunnus
end
