class HyvaksyttavatDokumentit < ActiveRecord::Migration
  def up
      create_table "hyvaksyttavat_dokumentit", primary_key: "tunnus", force: :cascade do |t|
        t.string   "yhtio",                 limit: 5,                default: "",  null: false
        t.string   "nimi",                  limit: 150,              default: "",  null: false
        t.text     "selite",                limit: 255,                            null: true
        t.string   "tila",                  limit: 2,                default: 0,   null: false
        t.string   "laatija",               limit: 50,               default: "",  null: false
        t.datetime "luontiaika",                                     default: 0,   null: false
        t.string   "muuttaja",              limit: 50,               default: "",  null: false
        t.datetime "muutospvm",                                      default: 0,   null: false
      end

      add_index "hyvaksyttavat_dokumentit", ["yhtio", "tila"], name: "yhtio_tila", unique: false, using: :btree
    end

    def down
      drop_table "hyvaksyttavat_dokumentit"
    end
end
