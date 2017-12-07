class SalesPriceChanges < ActiveRecord::Migration
  def up
    create_table :changelog do |t|
      t.string  :yhtio, limit: 5, default: "", null: false
      t.string  :table, limit: 150, default: "", null: false
      t.integer :key, default: 0, null: false
      t.string  :field, limit: 150, default: "", null: false
      t.string  :value_str, limit: 255, default: "", null: false
      t.string  :laatija, limit: 50, default: "", null: false
      t.datetime :luontiaika, null: false, default: 0
    end

    add_index :changelog, [:yhtio, :table, :key, :field, :luontiaika], name: "yhtio_table_key_field_luontiaika", unique: true

  end

  def down
    drop_table :changelog
  end
end
