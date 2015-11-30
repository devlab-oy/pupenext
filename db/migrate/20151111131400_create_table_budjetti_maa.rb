require File.expand_path('test/permission_helper')
include PermissionHelper

class CreateTableBudjettiMaa < ActiveRecord::Migration
  def up
    create_table :budjetti_maa do |t|
      t.string  :yhtio, limit: 5, default: "", null: false
      t.string  :kausi, limit: 6, default: "", null: false
      t.integer :maa_id, default: 0, null: false
      t.string  :osasto, limit: 150, default: "", null: false
      t.string  :try, limit: 150, default: "", null: false
      t.decimal :summa, limit: 12, precision: 12, scale: 2, default: 0.0, null: false
      t.decimal :maara, limit: 12, precision: 12, scale: 2, default: 0.0, null: false
      t.decimal :indeksi, limit: 12, precision: 12, scale: 2, default: 0.0, null: false
      t.string  :muuttaja, limit: 50, default: "", null: false
      t.string  :laatija, limit: 50, default: "", null: false
      t.datetime :luontiaika, null: false, default: 0
      t.datetime :muutospvm, null: false, default: 0
    end

    add_index :budjetti_maa, [:yhtio, :maa_id, :kausi, :osasto, :try], name: "mabu", unique: true

    PermissionHelper.add_item(
      program: 'Asiakkaat',
      name: 'Maiden myyntitavoitteet',
      uri: 'budjetinyllapito_tat.php',
      suburi: 'MAA'
    )
  end

  def down
    drop_table :budjetti_maa

    PermissionHelper.remove_all(
      uri: 'budjetinyllapito_tat.php',
      suburi: 'MAA'
    )
  end
end
