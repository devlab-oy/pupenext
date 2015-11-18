class CreateOnlineStoreThemes < ActiveRecord::Migration
  def change
    create_table :online_store_themes do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
