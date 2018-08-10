class ModifyProductTahtituote < ActiveRecord::Migration
  def up
    change_column :tuote, :tahtituote, :string, limit: 10, default: '', null: false
  end

  def down
    change_column :tuote, :tahtituote, :string, limit: 5, default: '', null: false
  end
end
