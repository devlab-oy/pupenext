class FixedAssets::Commodity < ActiveRecord::Base
  belongs_to :company
  has_one :voucher, foreign_key: :hyodyke_tunnus, class_name: 'Head::Voucher'
  has_many :commodity_rows

  def lock_all_rows
    commodity_rows.update_all(locked: true)
    voucher.rows.update_all(lukko: "X")
  end
end
