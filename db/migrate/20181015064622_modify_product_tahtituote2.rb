class ModifyProductTahtituote2 < ActiveRecord::Migration
  def up
    change_column :tuote, :tahtituote, :string, limit: 15, default: '', null: false
  end

  def down
    change_column :tuote, :tahtituote, :string, limit: 10, default: '', null: false
  end
end
