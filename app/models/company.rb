class Company < ActiveRecord::Base

  has_many :users, foreign_key: :yhtio, primary_key: :yhtio
  has_one :parameter, foreign_key: :yhtio, primary_key: :yhtio
  has_many :currency, foreign_key: :yhtio, primary_key: :yhtio
  has_many :accounting_vouchers, class_name: 'Accounting::Voucher',
    foreign_key: :yhtio, primary_key: :yhtio
  has_many :accounting_rows, class_name: 'Accounting::Row',
    foreign_key: :yhtio, primary_key: :yhtio
  has_many :accounting_attachments, class_name: 'Accounting::Attachment',
    foreign_key: :yhtio, primary_key: :yhtio
  has_many :accounting_fixed_assets_commodities, class_name: 'Accounting::FixedAssets::Commodity',
    foreign_key: :yhtio, primary_key: :yhtio
  has_many :accounting_fixed_assets_rows, class_name: 'Accounting::FixedAssets::Row',
    foreign_key: :yhtio, primary_key: :yhtio
  has_many :accounting_accounts, class_name: 'Accounting::Account',
    foreign_key: :yhtio, primary_key: :yhtio
  has_many :purchase_orders, foreign_key: :yhtio, primary_key: :yhtio
  # Map old database schema table to Company class
  self.table_name  = "yhtio"
  self.primary_key = "tunnus"

end
