class CreateOnlineStoreTypes < ActiveRecord::Migration
  def change
    create_table :online_store_types do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
