class FixedAssets::Commodity < ActiveRecord::Base
  belongs_to :company
  has_one :voucher, foreign_key: :hyodyke_tunnus, class_name: 'Head::Voucher'
  has_many :commodity_rows
end
