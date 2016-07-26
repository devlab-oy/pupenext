class AddFieldsForDynaaminenPuu < ActiveRecord::Migration
  def change
    add_column :dynaaminen_puu, :parent_id,      :integer, null: true,  default: nil, after: :laji
    add_column :dynaaminen_puu, :children_count, :integer, null: false, default: 0,   after: :laji

    change_column_null :dynaaminen_puu, :lft,    false
    change_column_null :dynaaminen_puu, :rgt,    false
    change_column_null :dynaaminen_puu, :syvyys, false

    change_column_default :dynaaminen_puu, :lft,    nil
    change_column_default :dynaaminen_puu, :rgt,    nil
    change_column_default :dynaaminen_puu, :syvyys, 0

    add_index :dynaaminen_puu, :parent_id
  end
end
