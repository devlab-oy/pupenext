require File.expand_path('test/permission_helper')
include PermissionHelper

class Dokumenttityypit < ActiveRecord::Migration
  def up
    create_table "hyvaksyttavat_dokumenttityypit", primary_key: "tunnus", force: :cascade do |t|
      t.string   "yhtio",                 limit: 5,                default: "",  null: false
      t.string   "tyyppi",                limit: 150,              default: "",  null: false
      t.string   "laatija",               limit: 50,               default: "",  null: false
      t.datetime "luontiaika",                                     default: 0,   null: false
      t.string   "muuttaja",              limit: 50,               default: "",  null: false
      t.datetime "muutospvm",                                      default: 0,   null: false
    end

    create_table "hyvaksyttavat_dokumenttityypit_kayttajat", primary_key: "tunnus", force: :cascade do |t|
      t.string   "yhtio",                 limit: 5,                default: "",  null: false
      t.integer  "doku_tyyppi_tunnus",    limit: 11,               default: 0,   null: false
      t.string   "kuka",                  limit: 50,               default: "",  null: false
      t.string   "laatija",               limit: 50,               default: "",  null: false
      t.datetime "luontiaika",                                     default: 0,   null: false
      t.string   "muuttaja",              limit: 50,               default: "",  null: false
      t.datetime "muutospvm",                                      default: 0,   null: false
    end

    add_column :hyvaksyttavat_dokumentit, :tiedostotyyppi, :string, limit: 150, default: '', null: false, after: :kommentit

    PermissionHelper.add_item(
      program: 'Dokumentit',
      name: 'Dokumenttityypit',
      uri: 'dokumenttityypit.php'
    )
  end

  def down
    drop_table "hyvaksyttavat_dokumenttityypit"
    drop_table "hyvaksyttavat_dokumenttityypit_kayttajat"

    remove_column :hyvaksyttavat_dokumentit, :tiedostotyyppi

    PermissionHelper.remove_all(
      program: 'Dokumentit',
      uri: 'dokumenttityypit.php'
    )
  end
end
