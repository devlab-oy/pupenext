class PurchaseOrder < ActiveRecord::Base
  include Searchable

  has_one :company, foreign_key: :yhtio, primary_key: :yhtio
  has_many :accounting_rows, class_name: 'Accounting::Row', foreign_key: :ltunnus

  # Only paid purchase orders for now
  default_scope { where("lasku.tila in ('H','Y','M','P','Q')") }

  # Map old database schema table to Accounting::Attachment class
  self.table_name = :lasku
  self.primary_key = :tunnus
end
