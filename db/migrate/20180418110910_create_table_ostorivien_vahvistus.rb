class CreateTableOstorivienVahvistus< ActiveRecord::Migration
  def up
    create_table "ostorivien_vahvistus", primary_key: "tunnus", force: :cascade do |t|
      t.string   "yhtio",                 limit: 5,                default: "",  null: false
      t.integer  "tilausrivin_tunnus",    limit: 11,               default: 0,  null: false
      t.string   "vahvistettu",           limit: 1,                default: "0", null: false
      t.datetime "vahvistettuaika",                                              null: false
      t.string   "laatija",               limit: 50,               default: "",  null: false
      t.datetime "luontiaika",                                                   null: false
    end

    add_index "ostorivien_vahvistus", ["yhtio", "tilausrivin_tunnus"], name: "yhtio_rivitunnus", unique: false, using: :btree
  end

  def down
    drop_table :ostorivien_vahvistus
  end
end
