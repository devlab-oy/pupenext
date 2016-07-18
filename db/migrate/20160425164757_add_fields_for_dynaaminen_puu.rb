class AddFieldsForDynaaminenPuu < ActiveRecord::Migration
  def change
    add_column :dynaaminen_puu, :parent_id,      :integer, null: true,  index: true, after: :laji
    add_column :dynaaminen_puu, :children_count, :integer, null: false, default: 0,  after: :laji
  end
end
