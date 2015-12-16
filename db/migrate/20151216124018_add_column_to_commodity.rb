class AddColumnToCommodity < ActiveRecord::Migration
  def change
    add_column :fixed_assets_commodities, :previous_btl_depreciations, :decimal, precision: 16, scale: 6, default: 0.0, after: :amount_sold
  end
end
