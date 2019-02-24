class LiitetiedostotExternalId < ActiveRecord::Migration
  def up
    add_column :liitetiedostot, :external_id, :string, limit: 25, default: '', null: false, after: :kayttotarkoitus

  end
  def down
    remove_column :liitetiedostot, :external_id
  end
end
