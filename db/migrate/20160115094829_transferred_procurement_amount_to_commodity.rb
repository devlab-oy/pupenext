class TransferredProcurementAmountToCommodity < ActiveRecord::Migration
  def change
    add_column :fixed_assets_commodities, :transferred_procurement_amount, :decimal, precision: 16, scale: 6, default: 0.0, after: :previous_btl_depreciations
  end
end
