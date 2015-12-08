class CreateSupplierProductInformations < ActiveRecord::Migration
  def change
    create_table :supplier_product_informations do |t|
      t.string :product_id, limit: 100
      t.string :product_name, limit: 150
      t.string :manufacturer_ean, limit: 13
      t.string :manufacturer_name, limit: 100
      t.integer :manufacturer_id
      t.string :manufacturer_part_number, limit: 100
      t.string :supplier_name, limit: 100
      t.integer :supplier_id
      t.string :supplier_ean, limit: 13
      t.string :supplier_part_number, limit: 100
      t.string :product_status, limit: 100
      t.string :short_description, limit: 250
      t.string :description, limit: 500
      t.string :category_text1, limit: 100
      t.string :category_text2, limit: 100
      t.string :category_text3, limit: 100
      t.string :category_text4, limit: 100
      t.integer :category_idn
      t.decimal :net_price, precision: 16, scale: 6
      t.decimal :net_retail_price, precision: 16, scale: 6
      t.integer :available_quantity
      t.date :available_next_date
      t.integer :available_next_quantity
      t.integer :warranty_months
      t.decimal :gross_mass, precision: 8, scale: 4
      t.boolean :end_of_life, null: false, default: false
      t.boolean :returnable, null: false, default: false
      t.boolean :cancelable, null: false, default: false
      t.string :warranty_text, limit: 100
      t.string :packaging_unit, limit: 100
      t.decimal :vat_rate, precision: 4, scale: 2
      t.integer :bid_price_id
      t.string :url_to_product, limit: 150
      t.integer :p_price_update
      t.integer :p_qty_update
      t.datetime :p_added_date
      t.datetime :p_last_update_date
      t.string :p_nakyvyys, limit: 100
      t.integer :p_tree_id

      t.timestamps null: false
    end
  end
end
