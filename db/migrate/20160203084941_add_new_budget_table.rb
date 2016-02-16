class AddNewBudgetTable < ActiveRecord::Migration
  def change
    create_table "budjetti_asiakasmyyja", primary_key: "tunnus", force: :cascade do |t|
      t.string   "yhtio",                 limit: 5,                default: "",  null: false
      t.string   "kausi",                 limit: 6,                default: "",  null: false
      t.integer  "asiakasmyyjan_tunnus",  limit: 4,                default: 0,   null: false
      t.string   "osasto",                limit: 150,              default: "",  null: false
      t.string   "try",                   limit: 150,              default: "",  null: false
      t.decimal  "summa",                 precision: 12, scale: 2, default: 0.0, null: false
      t.decimal  "maara",                 precision: 12, scale: 2, default: 0.0, null: false
      t.decimal  "indeksi",               precision: 12, scale: 2, default: 0.0, null: false
      t.string   "laatija",               limit: 50,               default: "",  null: false
      t.datetime "luontiaika",                                                   null: false
      t.datetime "muutospvm",                                                    null: false
      t.string   "muuttaja",              limit: 50,               default: "",  null: false
    end

    add_index "budjetti_asiakasmyyja", ["yhtio", "kausi", "asiakasmyyjan_tunnus", "osasto", "try"], name: "budjetti_asiakasmyyja", unique: true, using: :btree
  end
end
