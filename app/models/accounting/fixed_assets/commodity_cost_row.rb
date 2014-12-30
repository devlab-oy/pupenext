class Accounting::FixedAssets::CommodityCostRow < ActiveRecord::Base

  has_one :commodity, class_name: 'Accounting::FixedAssets::Commodity', primary_key: :hyodyke_tunnus
  has_one :accounting_row, class_name: 'Accounting::Row', primary_key: :tiliointirivi_tunnus, foreign_key: :tunnus

  self.table_name  = :accounting_fixed_assets_commodity_cost_rows
  self.primary_key = :tunnus

end
