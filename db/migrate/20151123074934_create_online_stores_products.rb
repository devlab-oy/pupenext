class CreateOnlineStoresProducts < ActiveRecord::Migration
  def change
    create_table :online_stores_products do |t|
      t.references :online_store, index: true, foreign_key: true
      t.references :product, index: true, foreign_key: true
    end
  end
end
