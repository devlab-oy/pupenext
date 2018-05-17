require File.expand_path('test/permission_helper')
include PermissionHelper

class HyvaksyttavatDokumentit < ActiveRecord::Migration
  def up
      create_table "hyvaksyttavat_dokumentit", primary_key: "tunnus", force: :cascade do |t|
        t.string   "yhtio",                 limit: 5,                default: "",  null: false
        t.string   "nimi",                  limit: 150,              default: "",  null: false
        t.text     "kuvaus",                limit: 255,                            null: true
        t.text     "kommentit",             limit: 255,                            null: true
        t.string   "tila",                  limit: 2,                default: 0,   null: false
        t.string   "hyvak1",                limit: 50,               default: "",  null: false
        t.datetime "h1time",                                                       null: false
        t.string   "hyvak2",                limit: 50,               default: "",  null: false
        t.datetime "h2time",                                                       null: false
        t.string   "hyvak3",                limit: 50,               default: "",  null: false
        t.datetime "h3time",                                                       null: false
        t.string   "hyvak4",                limit: 50,               default: "",  null: false
        t.datetime "h4time",                                                       null: false
        t.string   "hyvak5",                limit: 50,               default: "",  null: false
        t.datetime "h5time",                                                       null: false
        t.string   "hyvaksyja_nyt",         limit: 50,               default: "",  null: false
        t.string   "hyvaksynnanmuutos",     limit: 1,                default: "",  null: false
        t.string   "laatija",               limit: 50,               default: "",  null: false
        t.datetime "luontiaika",                                     default: 0,   null: false
        t.string   "muuttaja",              limit: 50,               default: "",  null: false
        t.datetime "muutospvm",                                      default: 0,   null: false
      end

      add_index "hyvaksyttavat_dokumentit", ["yhtio", "tila"], name: "yhtio_tila", unique: false, using: :btree

      PermissionHelper.add_item(
        program: 'Dokumentit',
        name: 'Uusi dokumentti',
        uri: 'uusi_dokumentti.php'
      )
      PermissionHelper.add_item(
        program: 'Dokumentit',
        name: 'Dokumenttien hyväksyntä',
        uri: 'dokumenttien_hyvaksynta.php'
      )
      PermissionHelper.add_item(
        program: 'Dokumentit',
        name: 'Hyväksynnän tila',
        uri: 'raportit.php',
        suburi: 'dokumenttien_hyvaksynta'
      )
      PermissionHelper.add_item(
        program: 'Dokumentit',
        name: 'Dokumentit',
        uri: 'dokumentti_raportti.php'
      )
    end

    def down
      drop_table "hyvaksyttavat_dokumentit"

      PermissionHelper.remove_all(
        program: 'Dokumentit',
        uri: 'raportit.php',
        suburi: 'dokumenttien_hyvaksynta'
      )
      PermissionHelper.remove_all(
        program: 'Dokumentit',
        uri: 'uusi_dokumentti.php'
      )
      PermissionHelper.remove_all(
        program: 'Dokumentit',
        uri: 'dokumenttien_hyvaksynta.php'
      )
      PermissionHelper.remove_all(
        program: 'Dokumentit',
        uri: 'dokumentti_raportti.php'
      )
    end
end
