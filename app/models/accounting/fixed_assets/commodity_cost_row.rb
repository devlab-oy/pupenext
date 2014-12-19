class Accounting::FixedAssets::CommodityCostRow < ActiveRecord::Base
  self.table_name  = :accounting_fixed_assets_commodity_cost_rows
  self.primary_key = :tunnus
end
