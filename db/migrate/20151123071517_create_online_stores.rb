class CreateOnlineStores < ActiveRecord::Migration
  def change
    create_table :online_stores do |t|
      t.string :name
      t.string :type
      t.references :online_store_theme, index: true, foreign_key: true
      t.references :company, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
