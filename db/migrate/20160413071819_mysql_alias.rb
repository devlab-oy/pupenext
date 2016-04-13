class MysqlAlias < ActiveRecord::Migration
  def change
    create_table "mysqlalias", primary_key: "tunnus", force: :cascade do |t|
      t.string   "yhtio",       limit: 5,     default: "", null: false
      t.string   "taulu",       limit: 150,   default: "", null: false
      t.string   "sarake",      limit: 150,   default: "", null: false
      t.string   "alias_set",   limit: 150,   default: "", null: false
      t.string   "nakyvyys",    limit: 1,     default: "", null: false
      t.text     "otsikko",     limit: 65535
      t.text     "nimitys",     limit: 65535
      t.string   "pakollisuus", limit: 10,    default: "", null: false
      t.text     "oletusarvo",  limit: 65535
      t.text     "ohjeteksti",  limit: 65535
      t.string   "laatija",     limit: 50,    default: "", null: false
      t.datetime "luontiaika",                              null: false
      t.datetime "muutospvm",                               null: false
      t.string   "muuttaja",    limit: 50,    default: "", null: false
    end

    add_index "mysqlalias", ["yhtio", "taulu", "sarake"], name: "yhtio_taulu_sarake", using: :btree

    # Siirretään rivit avainsana-taulusta mysqlalias-tauluun
    SELECT * FROM avainsana WHERE laji='MYSQLALIAS'

    while (row) {

      list(taulu, sarake) = explode(".", row.selite)

      INSERT INTO mysqlalias SET
      yhtio = yhtio
      taulu = taulu
      sarake = sarake
      alias_set = selitetark_2
      nakyvyys = nakyvyys
      nimitys = selitetark
      pakollisuus = selitetark_3
      oletusarvo = selitetark_4
      ohjeteksti = selitetark_5
      laatija = laatija
      luontiaika = luontiaika
      muutospvm = muutospvm
      muuttaja = muuttaja
    }

    DELETE FROM avainsana WHERE laji='MYSQLALIAS'

  end
end
