# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180801131537) do

  create_table "abc_aputaulu", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",              limit: 5,                            default: "",  null: false
    t.string   "tyyppi",             limit: 2,                            default: "",  null: false
    t.string   "luokka",             limit: 4,                            default: "",  null: false
    t.string   "luokka_osasto",      limit: 4,                            default: "",  null: false
    t.string   "luokka_try",         limit: 4,                            default: "",  null: false
    t.string   "luokka_trygroup",    limit: 4,                            default: "",  null: false
    t.string   "luokka_tuotemerkki", limit: 4,                            default: "",  null: false
    t.string   "tuoteno",            limit: 60,                           default: "",  null: false
    t.string   "nimitys",            limit: 50,                           default: "",  null: false
    t.string   "try",                limit: 50,                           default: "",  null: false
    t.string   "tuotemerkki",        limit: 30,                           default: "",  null: false
    t.string   "osasto",             limit: 50,                           default: "",  null: false
    t.integer  "myyjanro",           limit: 4,                            default: 0,   null: false
    t.integer  "ostajanro",          limit: 4,                            default: 0,   null: false
    t.string   "malli",              limit: 100,                          default: "",  null: false
    t.string   "mallitarkenne",      limit: 100,                          default: "",  null: false
    t.string   "status",             limit: 10,                           default: "",  null: false
    t.date     "saapumispvm",                                                           null: false
    t.integer  "saldo",              limit: 4,                            default: 0,   null: false
    t.date     "tulopvm",                                                               null: false
    t.integer  "rivia",              limit: 4,                            default: 0,   null: false
    t.decimal  "kpl",                            precision: 12, scale: 2, default: 0.0, null: false
    t.decimal  "summa",                          precision: 12, scale: 2, default: 0.0, null: false
    t.integer  "kerrat",             limit: 4,                            default: 0,   null: false
    t.decimal  "kate",                           precision: 12, scale: 2, default: 0.0, null: false
    t.decimal  "katepros",                       precision: 12, scale: 2, default: 0.0, null: false
    t.decimal  "puutekpl",                       precision: 12, scale: 2, default: 0.0, null: false
    t.integer  "puuterivia",         limit: 4,                            default: 0,   null: false
    t.integer  "osto_rivia",         limit: 4,                            default: 0,   null: false
    t.decimal  "osto_kpl",                       precision: 12, scale: 2, default: 0.0, null: false
    t.decimal  "osto_summa",                     precision: 12, scale: 2, default: 0.0, null: false
    t.integer  "osto_kerrat",        limit: 4,                            default: 0,   null: false
    t.decimal  "vararvo",                        precision: 12, scale: 2, default: 0.0, null: false
    t.decimal  "ostoeranarvo",                   precision: 12, scale: 2, default: 0.0, null: false
    t.decimal  "ostoerankpl",                    precision: 12, scale: 2, default: 0.0, null: false
    t.decimal  "palvelutaso",                    precision: 12, scale: 2, default: 0.0, null: false
    t.decimal  "myyntieranarvo",                 precision: 12, scale: 2, default: 0.0, null: false
    t.decimal  "myyntierankpl",                  precision: 12, scale: 2, default: 0.0, null: false
    t.decimal  "varaston_kiertonop",             precision: 12, scale: 2, default: 0.0, null: false
    t.decimal  "kustannus_yht",                  precision: 12, scale: 2, default: 0.0, null: false
    t.decimal  "kustannus_osto",                 precision: 12, scale: 2, default: 0.0, null: false
    t.decimal  "kustannus",                      precision: 12, scale: 2, default: 0.0, null: false
    t.datetime "tuote_luontiaika",                                                      null: false
  end

  add_index "abc_aputaulu", ["yhtio", "tuoteno"], name: "yhtio_tuoteno", using: :btree
  add_index "abc_aputaulu", ["yhtio", "tyyppi", "luokka", "summa"], name: "yhtio_tyyppi_luokka", using: :btree
  add_index "abc_aputaulu", ["yhtio", "tyyppi", "osasto", "try"], name: "yhtio_tyyppi_osasto_try", using: :btree
  add_index "abc_aputaulu", ["yhtio", "tyyppi", "try"], name: "yhtio_tyyppi_try", using: :btree
  add_index "abc_aputaulu", ["yhtio", "tyyppi", "tuotemerkki"], name: "yhtio_tyyppi_tuotemerkki", using: :btree
  add_index "abc_aputaulu", ["yhtio", "tyyppi", "tuoteno"], name: "yhtio_tyyppi_tuoteno", using: :btree

  create_table "abc_parametrit", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",                       limit: 5,                          default: "",  null: false
    t.string   "tyyppi",                      limit: 2,                          default: "",  null: false
    t.string   "luokka",                      limit: 4,                          default: "",  null: false
    t.integer  "osuusprosentti",              limit: 4,                          default: 0,   null: false
    t.decimal  "kiertonopeus_tavoite",                   precision: 5, scale: 2, default: 0.0, null: false
    t.decimal  "palvelutaso_tavoite",                    precision: 5, scale: 2, default: 0.0, null: false
    t.decimal  "varmuusvarasto_pv",                      precision: 5, scale: 2, default: 0.0, null: false
    t.decimal  "toimittajan_toimitusaika_pv",            precision: 5, scale: 2, default: 0.0, null: false
    t.string   "kulujen_taso",                limit: 20,                         default: "",  null: false
    t.string   "laatija",                     limit: 50,                         default: "",  null: false
    t.datetime "luontiaika",                                                                   null: false
    t.datetime "muutospvm",                                                                    null: false
    t.string   "muuttaja",                    limit: 50,                         default: "",  null: false
  end

  create_table "asiakas", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",                            limit: 5,                              default: "",  null: false
    t.string   "laji",                             limit: 1,                              default: "",  null: false
    t.string   "tila",                             limit: 150,                            default: "",  null: false
    t.string   "ytunnus",                          limit: 15,                             default: "",  null: false
    t.string   "ovttunnus",                        limit: 25,                             default: "",  null: false
    t.string   "nimi",                             limit: 60,                             default: "",  null: false
    t.string   "nimitark",                         limit: 60,                             default: "",  null: false
    t.string   "osoite",                           limit: 55,                             default: "",  null: false
    t.string   "postino",                          limit: 15,                             default: "",  null: false
    t.string   "postitp",                          limit: 35,                             default: "",  null: false
    t.integer  "toimipaikka",                      limit: 4,                              default: 0,   null: false
    t.string   "kunta",                            limit: 150,                            default: "",  null: false
    t.string   "laani",                            limit: 150,                            default: "",  null: false
    t.string   "maa",                              limit: 2,                              default: "",  null: false
    t.string   "kansalaisuus",                     limit: 100,                            default: "",  null: false
    t.string   "tyonantaja",                       limit: 100,                            default: "",  null: false
    t.string   "ammatti",                          limit: 100,                            default: "",  null: false
    t.string   "email",                            limit: 255,                            default: "",  null: false
    t.string   "lasku_email",                      limit: 255,                            default: "",  null: false
    t.string   "talhal_email",                     limit: 255,                            default: "",  null: false
    t.string   "puhelin",                          limit: 100,                            default: "",  null: false
    t.string   "gsm",                              limit: 100,                            default: "",  null: false
    t.string   "tyopuhelin",                       limit: 100,                            default: "",  null: false
    t.string   "fax",                              limit: 100,                            default: "",  null: false
    t.string   "toim_ovttunnus",                   limit: 25,                             default: "",  null: false
    t.string   "toim_nimi",                        limit: 60,                             default: "",  null: false
    t.string   "toim_nimitark",                    limit: 60,                             default: "",  null: false
    t.string   "toim_osoite",                      limit: 55,                             default: "",  null: false
    t.string   "toim_postino",                     limit: 15,                             default: "",  null: false
    t.string   "toim_postitp",                     limit: 35,                             default: "",  null: false
    t.string   "toim_maa",                         limit: 2,                              default: "",  null: false
    t.string   "kolm_ovttunnus",                   limit: 25,                             default: "",  null: false
    t.string   "kolm_nimi",                        limit: 60,                             default: "",  null: false
    t.string   "kolm_nimitark",                    limit: 60,                             default: "",  null: false
    t.string   "kolm_osoite",                      limit: 55,                             default: "",  null: false
    t.string   "kolm_postino",                     limit: 15,                             default: "",  null: false
    t.string   "kolm_postitp",                     limit: 35,                             default: "",  null: false
    t.string   "kolm_maa",                         limit: 2,                              default: "",  null: false
    t.string   "laskutus_nimi",                    limit: 60,                             default: "",  null: false
    t.string   "laskutus_nimitark",                limit: 60,                             default: "",  null: false
    t.string   "laskutus_osoite",                  limit: 60,                             default: "",  null: false
    t.string   "laskutus_postino",                 limit: 60,                             default: "",  null: false
    t.string   "laskutus_postitp",                 limit: 60,                             default: "",  null: false
    t.string   "laskutus_maa",                     limit: 60,                             default: "",  null: false
    t.string   "maksukehotuksen_osoitetiedot",     limit: 1,                              default: "",  null: false
    t.string   "konserni",                         limit: 60,                             default: "",  null: false
    t.string   "asiakasnro",                       limit: 20,                             default: "",  null: false
    t.string   "piiri",                            limit: 150,                            default: "",  null: false
    t.string   "ryhma",                            limit: 150,                            default: "",  null: false
    t.string   "osasto",                           limit: 50,                             default: "",  null: false
    t.string   "verkkotunnus",                     limit: 76,                             default: "",  null: false
    t.string   "kieli",                            limit: 2,                              default: "",  null: false
    t.string   "chn",                              limit: 3,                              default: "",  null: false
    t.string   "konserniyhtio",                    limit: 1,                              default: "",  null: false
    t.text     "fakta",                            limit: 65535
    t.text     "myynti_kommentti1",                limit: 65535
    t.text     "sisviesti2",                       limit: 65535
    t.text     "sisviesti1",                       limit: 65535
    t.string   "tilaus_viesti",                    limit: 70,                             default: "",  null: false
    t.text     "kuljetusohje",                     limit: 65535
    t.string   "selaus",                           limit: 55,                             default: "",  null: false
    t.decimal  "alv",                                            precision: 5,  scale: 2, default: 0.0, null: false
    t.string   "valkoodi",                         limit: 3,                              default: "",  null: false
    t.integer  "maksuehto",                        limit: 4,                              default: 0,   null: false
    t.string   "toimitustapa",                     limit: 50,                             default: "",  null: false
    t.string   "rahtivapaa",                       limit: 1,                              default: "",  null: false
    t.decimal  "rahtivapaa_alarajasumma",                        precision: 12, scale: 2, default: 0.0, null: false
    t.string   "kuljetusvakuutus_tyyppi",          limit: 1,                              default: "",  null: false
    t.string   "toimitusehto",                     limit: 60,                             default: "",  null: false
    t.string   "tilausvahvistus",                  limit: 15,                             default: "",  null: false
    t.string   "tilausvahvistus_jttoimituksista",  limit: 1,                              default: "",  null: false
    t.string   "jt_toimitusaika_email_vahvistus",  limit: 1,                              default: "",  null: false
    t.string   "toimitusvahvistus",                limit: 50,                             default: "",  null: false
    t.integer  "kerayspoikkeama",                  limit: 4,                              default: 0,   null: false
    t.string   "keraysvahvistus_lahetys",          limit: 1,                              default: "",  null: false
    t.string   "keraysvahvistus_email",            limit: 255,                            default: "",  null: false
    t.string   "kerayserat",                       limit: 1,                              default: "",  null: false
    t.string   "lahetetyyppi",                     limit: 150,                            default: "",  null: false
    t.string   "lahetteen_jarjestys",              limit: 1,                              default: "",  null: false
    t.string   "lahetteen_jarjestys_suunta",       limit: 4,                              default: "",  null: false
    t.string   "koontilahete_kollitiedot",         limit: 1,                              default: "",  null: false
    t.integer  "laskutyyppi",                      limit: 4,                              default: 0,   null: false
    t.integer  "laskutusvkopv",                    limit: 4,                              default: 0,   null: false
    t.string   "maksusopimus_toimitus",            limit: 1,                              default: "",  null: false
    t.string   "laskun_jarjestys",                 limit: 1,                              default: "",  null: false
    t.string   "laskun_jarjestys_suunta",          limit: 4,                              default: "",  null: false
    t.string   "extranet_tilaus_varaa_saldoa",     limit: 3,                              default: "",  null: false
    t.string   "vienti",                           limit: 1,                              default: "",  null: false
    t.string   "ketjutus",                         limit: 1,                              default: "",  null: false
    t.string   "koontilaskut_yhdistetaan",         limit: 1,                              default: "",  null: false
    t.string   "luokka",                           limit: 50,                             default: "",  null: false
    t.string   "jtkielto",                         limit: 1,                              default: "",  null: false
    t.integer  "jtrivit",                          limit: 4,                              default: 0,   null: false
    t.integer  "myyjanro",                         limit: 4,                              default: 0,   null: false
    t.decimal  "erikoisale",                                     precision: 5,  scale: 2, default: 0.0, null: false
    t.string   "myyntikielto",                     limit: 1,                              default: "",  null: false
    t.string   "myynninseuranta",                  limit: 1,                              default: "",  null: false
    t.decimal  "luottoraja",                                     precision: 12, scale: 2, default: 0.0, null: false
    t.string   "luottovakuutettu",                 limit: 1,                              default: "",  null: false
    t.decimal  "kuluprosentti",                                  precision: 8,  scale: 3, default: 0.0, null: false
    t.decimal  "tuntihinta",                                     precision: 7,  scale: 2, default: 0.0, null: false
    t.decimal  "tuntikerroin",                                   precision: 7,  scale: 2, default: 0.0, null: false
    t.decimal  "hintakerroin",                                   precision: 7,  scale: 2, default: 0.0, null: false
    t.decimal  "pientarvikelisa",                                precision: 7,  scale: 2, default: 0.0, null: false
    t.string   "laskunsummapyoristys",             limit: 1,                              default: "",  null: false
    t.string   "laskutuslisa",                     limit: 1,                              default: "",  null: false
    t.string   "panttitili",                       limit: 1,                              default: "",  null: false
    t.string   "tilino",                           limit: 6,                              default: "",  null: false
    t.string   "tilino_eu",                        limit: 6,                              default: "",  null: false
    t.string   "tilino_ei_eu",                     limit: 6,                              default: "",  null: false
    t.string   "tilino_kaanteinen",                limit: 6,                              default: "",  null: false
    t.string   "tilino_marginaali",                limit: 6,                              default: "",  null: false
    t.string   "tilino_osto_marginaali",           limit: 6,                              default: "",  null: false
    t.string   "tilino_triang",                    limit: 6,                              default: "",  null: false
    t.integer  "kustannuspaikka",                  limit: 4,                              default: 0,   null: false
    t.integer  "kohde",                            limit: 4,                              default: 0,   null: false
    t.integer  "projekti",                         limit: 4,                              default: 0,   null: false
    t.string   "laatija",                          limit: 50,                             default: "",  null: false
    t.datetime "luontiaika",                                                                            null: false
    t.datetime "muutospvm",                                                                             null: false
    t.string   "muuttaja",                         limit: 50,                             default: "",  null: false
    t.string   "flag_1",                           limit: 2,                              default: "",  null: false
    t.string   "flag_2",                           limit: 2,                              default: "",  null: false
    t.string   "flag_3",                           limit: 2,                              default: "",  null: false
    t.string   "flag_4",                           limit: 2,                              default: "",  null: false
    t.string   "maa_maara",                        limit: 2,                              default: "",  null: false
    t.string   "sisamaan_kuljetus",                limit: 30,                             default: "",  null: false
    t.string   "sisamaan_kuljetus_kansallisuus",   limit: 2,                              default: "",  null: false
    t.integer  "sisamaan_kuljetusmuoto",           limit: 4,                              default: 0,   null: false
    t.integer  "kontti",                           limit: 4,                              default: 0,   null: false
    t.string   "aktiivinen_kuljetus",              limit: 30,                             default: "",  null: false
    t.string   "aktiivinen_kuljetus_kansallisuus", limit: 2,                              default: "",  null: false
    t.integer  "kauppatapahtuman_luonne",          limit: 4,                              default: 0,   null: false
    t.integer  "kuljetusmuoto",                    limit: 4,                              default: 0,   null: false
    t.string   "poistumistoimipaikka_koodi",       limit: 8,                              default: "",  null: false
  end

  add_index "asiakas", ["nimi"], name: "asiakasnimi", type: :fulltext
  add_index "asiakas", ["nimitark"], name: "asiakasnimitark", type: :fulltext
  add_index "asiakas", ["toim_nimi"], name: "asiakastoim_nimi", type: :fulltext
  add_index "asiakas", ["toim_nimitark"], name: "asiakastoim_nimitark", type: :fulltext
  add_index "asiakas", ["yhtio", "asiakasnro"], name: "asno_index", using: :btree
  add_index "asiakas", ["yhtio", "osasto", "ryhma"], name: "yhtio_osasto_ryhma", using: :btree
  add_index "asiakas", ["yhtio", "ovttunnus"], name: "ovttunnus_index", using: :btree
  add_index "asiakas", ["yhtio", "toim_ovttunnus"], name: "toim_ovttunnus_index", using: :btree
  add_index "asiakas", ["yhtio", "ytunnus"], name: "ytunnus_index", using: :btree

  create_table "asiakasalennus", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",             limit: 5,                           default: "",  null: false
    t.string   "tuoteno",           limit: 60,                          default: "",  null: false
    t.string   "ryhma",             limit: 15,                          default: "",  null: false
    t.integer  "asiakas",           limit: 4,                           default: 0,   null: false
    t.string   "ytunnus",           limit: 15,                          default: "",  null: false
    t.string   "asiakas_ryhma",     limit: 150,                         default: "",  null: false
    t.integer  "asiakas_segmentti", limit: 8,                           default: 0,   null: false
    t.string   "piiri",             limit: 150,                         default: "",  null: false
    t.integer  "campaign_id",       limit: 4
    t.decimal  "alennus",                       precision: 5, scale: 2, default: 0.0, null: false
    t.integer  "alennuslaji",       limit: 4,                           default: 1,   null: false
    t.integer  "minkpl",            limit: 4,                           default: 0,   null: false
    t.string   "monikerta",         limit: 1,                           default: "",  null: false
    t.date     "alkupvm",                                                             null: false
    t.date     "loppupvm",                                                            null: false
    t.string   "laatija",           limit: 50,                          default: "",  null: false
    t.datetime "luontiaika",                                                          null: false
    t.datetime "muutospvm",                                                           null: false
    t.string   "muuttaja",          limit: 50,                          default: "",  null: false
  end

  add_index "asiakasalennus", ["yhtio", "asiakas", "ryhma"], name: "yhtio_asiakas_ryhma", using: :btree
  add_index "asiakasalennus", ["yhtio", "asiakas", "tuoteno"], name: "yhtio_asiakas_tuoteno", using: :btree
  add_index "asiakasalennus", ["yhtio", "asiakas_ryhma", "ryhma"], name: "yhtio_asiakasryhma_ryhma", using: :btree
  add_index "asiakasalennus", ["yhtio", "asiakas_ryhma", "tuoteno"], name: "yhtio_asiakasryhma_tuoteno", using: :btree
  add_index "asiakasalennus", ["yhtio", "asiakas_segmentti", "ryhma"], name: "yhtio_asiakas_segmentti_ryhma", using: :btree
  add_index "asiakasalennus", ["yhtio", "asiakas_segmentti", "tuoteno"], name: "yhtio_asiakas_segmentti_tuoteno", using: :btree
  add_index "asiakasalennus", ["yhtio", "piiri", "ryhma"], name: "yhtio_piiri_ryhma", using: :btree
  add_index "asiakasalennus", ["yhtio", "piiri", "tuoteno"], name: "yhtio_piiri_tuoteno", using: :btree
  add_index "asiakasalennus", ["yhtio", "tuoteno"], name: "yhtio_tuoteno", using: :btree
  add_index "asiakasalennus", ["yhtio", "ytunnus", "ryhma"], name: "yhtio_ytunnus_ryhma", using: :btree
  add_index "asiakasalennus", ["yhtio", "ytunnus", "tuoteno"], name: "yhtio_ytunnus_tuoteno", using: :btree

  create_table "asiakashinta", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",             limit: 5,                            default: "",  null: false
    t.string   "tuoteno",           limit: 60,                           default: "",  null: false
    t.string   "ryhma",             limit: 15,                           default: "",  null: false
    t.integer  "asiakas",           limit: 4,                            default: 0,   null: false
    t.string   "ytunnus",           limit: 15,                           default: "",  null: false
    t.string   "asiakas_ryhma",     limit: 150,                          default: "",  null: false
    t.integer  "asiakas_segmentti", limit: 8,                            default: 0,   null: false
    t.string   "piiri",             limit: 150,                          default: "",  null: false
    t.integer  "campaign_id",       limit: 4
    t.decimal  "hinta",                         precision: 16, scale: 6, default: 0.0, null: false
    t.string   "valkoodi",          limit: 3,                            default: "",  null: false
    t.integer  "minkpl",            limit: 4,                            default: 0,   null: false
    t.integer  "maxkpl",            limit: 4,                            default: 0,   null: false
    t.date     "alkupvm",                                                              null: false
    t.date     "loppupvm",                                                             null: false
    t.string   "laji",              limit: 1,                            default: "",  null: false
    t.string   "laatija",           limit: 50,                           default: "",  null: false
    t.datetime "luontiaika",                                                           null: false
    t.datetime "muutospvm",                                                            null: false
    t.string   "muuttaja",          limit: 50,                           default: "",  null: false
  end

  add_index "asiakashinta", ["yhtio", "asiakas", "ryhma"], name: "yhtio_asiakas_ryhma", using: :btree
  add_index "asiakashinta", ["yhtio", "asiakas", "tuoteno"], name: "yhtio_asiakas_tuoteno", using: :btree
  add_index "asiakashinta", ["yhtio", "asiakas_ryhma", "ryhma"], name: "yhtio_asiakasryhma_ryhma", using: :btree
  add_index "asiakashinta", ["yhtio", "asiakas_ryhma", "tuoteno"], name: "yhtio_asiakasryhma_tuoteno", using: :btree
  add_index "asiakashinta", ["yhtio", "asiakas_segmentti", "ryhma"], name: "yhtio_asiakas_segmentti_ryhma", using: :btree
  add_index "asiakashinta", ["yhtio", "asiakas_segmentti", "tuoteno"], name: "yhtio_asiakas_segmentti_tuoteno", using: :btree
  add_index "asiakashinta", ["yhtio", "piiri", "ryhma"], name: "yhtio_piiri_ryhma", using: :btree
  add_index "asiakashinta", ["yhtio", "piiri", "tuoteno"], name: "yhtio_piiri_tuoteno", using: :btree
  add_index "asiakashinta", ["yhtio", "tuoteno"], name: "yhtio_tuoteno", using: :btree
  add_index "asiakashinta", ["yhtio", "ytunnus", "ryhma"], name: "yhtio_ytunnus_ryhma", using: :btree
  add_index "asiakashinta", ["yhtio", "ytunnus", "tuoteno"], name: "yhtio_ytunnus_tuoteno", using: :btree

  create_table "asiakaskommentti", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",      limit: 5,     default: "", null: false
    t.text     "kommentti",  limit: 65535
    t.string   "tuoteno",    limit: 60,    default: "", null: false
    t.string   "ytunnus",    limit: 15,    default: "", null: false
    t.string   "tyyppi",     limit: 1,     default: "", null: false
    t.string   "laatija",    limit: 50,    default: "", null: false
    t.datetime "luontiaika",                            null: false
    t.datetime "muutospvm",                             null: false
    t.string   "muuttaja",   limit: 50,    default: "", null: false
  end

  add_index "asiakaskommentti", ["yhtio", "ytunnus", "tuoteno"], name: "yhtio_ytunnus_tuoteno", using: :btree

  create_table "asiakkaan_avainsanat", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",        limit: 5,     default: "", null: false
    t.integer  "liitostunnus", limit: 4,     default: 0,  null: false
    t.string   "kieli",        limit: 2,     default: "", null: false
    t.string   "laji",         limit: 150,   default: "", null: false
    t.text     "avainsana",    limit: 65535
    t.text     "tarkenne",     limit: 65535
    t.string   "muuttaja",     limit: 50,    default: "", null: false
    t.string   "laatija",      limit: 50,    default: "", null: false
    t.datetime "luontiaika",                              null: false
    t.datetime "muutospvm",                               null: false
  end

  add_index "asiakkaan_avainsanat", ["yhtio", "laji"], name: "yhtio_laji", using: :btree
  add_index "asiakkaan_avainsanat", ["yhtio", "liitostunnus"], name: "yhtio_liitostunnus", using: :btree

  create_table "asn_sanomat", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",              limit: 5,                              default: "",  null: false
    t.string   "laji",               limit: 3,                              default: "",  null: false
    t.string   "toimittajanumero",   limit: 20,                             default: "",  null: false
    t.string   "asn_numero",         limit: 20,                             default: "",  null: false
    t.string   "sscc_koodi",         limit: 20,                             default: "",  null: false
    t.datetime "saapumispvm",                                                             null: false
    t.text     "vastaanottaja",      limit: 65535
    t.integer  "tilausnumero",       limit: 4,                              default: 0,   null: false
    t.text     "tilausrivi",         limit: 65535
    t.string   "paketintunniste",    limit: 30,                             default: "",  null: false
    t.string   "paketinnumero",      limit: 5,                              default: "",  null: false
    t.string   "lahetyslistannro",   limit: 30,                             default: "",  null: false
    t.string   "tuoteno",            limit: 60,                             default: "",  null: false
    t.string   "toim_tuoteno",       limit: 60,                             default: "",  null: false
    t.string   "toim_tuoteno2",      limit: 60,                             default: "",  null: false
    t.decimal  "kappalemaara",                     precision: 12, scale: 2, default: 0.0, null: false
    t.decimal  "hinta",                            precision: 16, scale: 6, default: 0.0, null: false
    t.decimal  "keikkarivinhinta",                 precision: 16, scale: 6, default: 0.0, null: false
    t.decimal  "lisakulu",                         precision: 12, scale: 6, default: 0.0, null: false
    t.decimal  "kulu",                             precision: 12, scale: 6, default: 0.0, null: false
    t.decimal  "pakkauskulu",                      precision: 12, scale: 6, default: 0.0, null: false
    t.decimal  "rahtikulu",                        precision: 12, scale: 6, default: 0.0, null: false
    t.decimal  "ale1",                             precision: 5,  scale: 2, default: 0.0, null: false
    t.decimal  "ale2",                             precision: 5,  scale: 2, default: 0.0, null: false
    t.decimal  "ale3",                             precision: 5,  scale: 2, default: 0.0, null: false
    t.decimal  "lasku_ale1",                       precision: 5,  scale: 2, default: 0.0, null: false
    t.decimal  "lasku_ale2",                       precision: 5,  scale: 2, default: 0.0, null: false
    t.decimal  "lasku_ale3",                       precision: 5,  scale: 2, default: 0.0, null: false
    t.string   "tilausrivinpositio", limit: 10,                             default: "",  null: false
    t.string   "status",             limit: 1,                              default: "",  null: false
    t.string   "laatija",            limit: 50,                             default: "",  null: false
    t.datetime "luontiaika",                                                              null: false
    t.datetime "muutospvm",                                                               null: false
    t.string   "muuttaja",           limit: 50,                             default: "",  null: false
  end

  add_index "asn_sanomat", ["tilausrivi"], name: "fulltext_tilausrivi", type: :fulltext
  add_index "asn_sanomat", ["yhtio", "laji", "toimittajanumero", "asn_numero"], name: "yhtio_laji_toimittajanumero_asn_numero", using: :btree
  add_index "asn_sanomat", ["yhtio", "status", "tuoteno", "toim_tuoteno", "toimittajanumero"], name: "yhtio_status_toimtuoteno_toimnro", using: :btree
  add_index "asn_sanomat", ["yhtio", "status", "tuoteno"], name: "yhtio_status_tuoteno", using: :btree

  create_table "avainsana", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",        limit: 5,     default: "", null: false
    t.integer  "perhe",        limit: 4,     default: 0,  null: false
    t.string   "kieli",        limit: 2,     default: "", null: false
    t.string   "laji",         limit: 15,    default: "", null: false
    t.string   "nakyvyys",     limit: 1,     default: "", null: false
    t.string   "selite",       limit: 150,   default: "", null: false
    t.text     "selitetark",   limit: 65535
    t.text     "selitetark_2", limit: 65535
    t.text     "selitetark_3", limit: 65535
    t.text     "selitetark_4", limit: 65535
    t.text     "selitetark_5", limit: 65535
    t.integer  "jarjestys",    limit: 4,     default: 0,  null: false
    t.string   "laatija",      limit: 50,    default: "", null: false
    t.datetime "luontiaika",                              null: false
    t.datetime "muutospvm",                               null: false
    t.string   "muuttaja",     limit: 50,    default: "", null: false
  end

  add_index "avainsana", ["yhtio", "laji", "perhe", "kieli"], name: "yhtio_laji_perhe_kieli", using: :btree
  add_index "avainsana", ["yhtio", "laji", "selite"], name: "yhtio_laji_selite", using: :btree
  add_index "avainsana", ["yhtio", "laji", "selitetark"], name: "yhtio_laji_selitetark", length: {"yhtio"=>nil, "laji"=>nil, "selitetark"=>100}, using: :btree
  add_index "avainsana", ["yhtio", "laji", "selitetark_3"], name: "yhtio_laji_selitetark3", length: {"yhtio"=>nil, "laji"=>nil, "selitetark_3"=>100}, using: :btree

  create_table "budjetti", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",      limit: 5,                           default: "",  null: false
    t.string   "kausi",      limit: 6,                           default: "",  null: false
    t.string   "taso",       limit: 20,                          default: "",  null: false
    t.string   "tili",       limit: 6,                           default: "",  null: false
    t.integer  "kustp",      limit: 4,                           default: 0,   null: false
    t.integer  "kohde",      limit: 4,                           default: 0,   null: false
    t.integer  "projekti",   limit: 4,                           default: 0,   null: false
    t.decimal  "summa",                 precision: 12, scale: 2, default: 0.0, null: false
    t.string   "tyyppi",     limit: 1,                           default: "",  null: false
    t.string   "laatija",    limit: 50,                          default: "",  null: false
    t.datetime "luontiaika",                                                   null: false
    t.datetime "muutospvm",                                                    null: false
    t.string   "muuttaja",   limit: 50,                          default: "",  null: false
  end

  add_index "budjetti", ["yhtio", "taso", "kausi"], name: "yhtio_taso_kausi", using: :btree

  create_table "budjetti_asiakas", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",            limit: 5,                            default: "",  null: false
    t.string   "kausi",            limit: 6,                            default: "",  null: false
    t.integer  "asiakkaan_tunnus", limit: 4,                            default: 0,   null: false
    t.string   "osasto",           limit: 150,                          default: "",  null: false
    t.string   "try",              limit: 150,                          default: "",  null: false
    t.decimal  "summa",                        precision: 12, scale: 2, default: 0.0, null: false
    t.decimal  "maara",                        precision: 12, scale: 2, default: 0.0, null: false
    t.decimal  "indeksi",                      precision: 12, scale: 2, default: 0.0, null: false
    t.string   "laatija",          limit: 50,                           default: "",  null: false
    t.datetime "luontiaika",                                                          null: false
    t.datetime "muutospvm",                                                           null: false
    t.string   "muuttaja",         limit: 50,                           default: "",  null: false
  end

  add_index "budjetti_asiakas", ["yhtio", "kausi", "asiakkaan_tunnus", "osasto", "try"], name: "asbu", unique: true, using: :btree

  create_table "budjetti_asiakasmyyja", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",                limit: 5,                            default: "",  null: false
    t.string   "kausi",                limit: 6,                            default: "",  null: false
    t.integer  "asiakasmyyjan_tunnus", limit: 4,                            default: 0,   null: false
    t.string   "osasto",               limit: 150,                          default: "",  null: false
    t.string   "try",                  limit: 150,                          default: "",  null: false
    t.decimal  "summa",                            precision: 12, scale: 2, default: 0.0, null: false
    t.decimal  "maara",                            precision: 12, scale: 2, default: 0.0, null: false
    t.decimal  "indeksi",                          precision: 12, scale: 2, default: 0.0, null: false
    t.string   "laatija",              limit: 50,                           default: "",  null: false
    t.datetime "luontiaika",                                                              null: false
    t.datetime "muutospvm",                                                               null: false
    t.string   "muuttaja",             limit: 50,                           default: "",  null: false
  end

  add_index "budjetti_asiakasmyyja", ["yhtio", "kausi", "asiakasmyyjan_tunnus", "osasto", "try"], name: "budjetti_asiakasmyyja", unique: true, using: :btree

  create_table "budjetti_maa", force: :cascade do |t|
    t.string   "yhtio",      limit: 5,                            default: "",  null: false
    t.string   "kausi",      limit: 6,                            default: "",  null: false
    t.integer  "maa_id",     limit: 4,                            default: 0,   null: false
    t.string   "osasto",     limit: 150,                          default: "",  null: false
    t.string   "try",        limit: 150,                          default: "",  null: false
    t.decimal  "summa",                  precision: 12, scale: 2, default: 0.0, null: false
    t.decimal  "maara",                  precision: 12, scale: 2, default: 0.0, null: false
    t.decimal  "indeksi",                precision: 12, scale: 2, default: 0.0, null: false
    t.string   "muuttaja",   limit: 50,                           default: "",  null: false
    t.string   "laatija",    limit: 50,                           default: "",  null: false
    t.datetime "luontiaika",                                                    null: false
    t.datetime "muutospvm",                                                     null: false
  end

  add_index "budjetti_maa", ["yhtio", "maa_id", "kausi", "osasto", "try"], name: "mabu", unique: true, using: :btree

  create_table "budjetti_myyja", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",         limit: 5,                            default: "",  null: false
    t.string   "kausi",         limit: 6,                            default: "",  null: false
    t.integer  "myyjan_tunnus", limit: 4,                            default: 0,   null: false
    t.string   "osasto",        limit: 150,                          default: "",  null: false
    t.string   "try",           limit: 150,                          default: "",  null: false
    t.decimal  "summa",                     precision: 12, scale: 2, default: 0.0, null: false
    t.decimal  "maara",                     precision: 12, scale: 2, default: 0.0, null: false
    t.decimal  "indeksi",                   precision: 12, scale: 2, default: 0.0, null: false
    t.string   "laatija",       limit: 50,                           default: "",  null: false
    t.datetime "luontiaika",                                                       null: false
    t.datetime "muutospvm",                                                        null: false
    t.string   "muuttaja",      limit: 50,                           default: "",  null: false
  end

  add_index "budjetti_myyja", ["yhtio", "kausi", "myyjan_tunnus", "osasto", "try"], name: "budjetti_myyja", unique: true, using: :btree

  create_table "budjetti_toimittaja", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",              limit: 5,                            default: "",  null: false
    t.string   "kausi",              limit: 6,                            default: "",  null: false
    t.integer  "toimittajan_tunnus", limit: 4,                            default: 0,   null: false
    t.string   "osasto",             limit: 150,                          default: "",  null: false
    t.string   "try",                limit: 150,                          default: "",  null: false
    t.decimal  "summa",                          precision: 12, scale: 2, default: 0.0, null: false
    t.decimal  "maara",                          precision: 12, scale: 2, default: 0.0, null: false
    t.decimal  "indeksi",                        precision: 12, scale: 2, default: 0.0, null: false
    t.string   "laatija",            limit: 50,                           default: "",  null: false
    t.datetime "luontiaika",                                                            null: false
    t.datetime "muutospvm",                                                             null: false
    t.string   "muuttaja",           limit: 50,                           default: "",  null: false
  end

  add_index "budjetti_toimittaja", ["yhtio", "kausi", "toimittajan_tunnus", "osasto", "try"], name: "tobu", unique: true, using: :btree

  create_table "budjetti_tuote", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",      limit: 5,                            default: "",  null: false
    t.string   "kausi",      limit: 6,                            default: "",  null: false
    t.string   "tuoteno",    limit: 60,                           default: "",  null: false
    t.string   "osasto",     limit: 150,                          default: "",  null: false
    t.string   "try",        limit: 150,                          default: "",  null: false
    t.decimal  "summa",                  precision: 12, scale: 2, default: 0.0, null: false
    t.decimal  "maara",                  precision: 12, scale: 2, default: 0.0, null: false
    t.decimal  "indeksi",                precision: 5,  scale: 2, default: 0.0, null: false
    t.string   "laatija",    limit: 50,                           default: "",  null: false
    t.datetime "luontiaika",                                                    null: false
    t.datetime "muutospvm",                                                     null: false
    t.string   "muuttaja",   limit: 50,                           default: "",  null: false
  end

  add_index "budjetti_tuote", ["yhtio", "kausi", "tuoteno", "osasto", "try"], name: "tubu", unique: true, length: {"yhtio"=>nil, "kausi"=>nil, "tuoteno"=>nil, "osasto"=>50, "try"=>50}, using: :btree
  add_index "budjetti_tuote", ["yhtio", "tuoteno", "kausi"], name: "yhtio_tuote_kausi", using: :btree

  create_table "campaigns", force: :cascade do |t|
    t.string   "name",        limit: 60,  default: "",   null: false
    t.string   "description", limit: 255, default: "",   null: false
    t.boolean  "active",                  default: true, null: false
    t.integer  "company_id",  limit: 4
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "campaigns", ["company_id"], name: "index_campaigns_on_company_id", using: :btree

  create_table "changelog", force: :cascade do |t|
    t.string   "yhtio",         limit: 5,   default: "", null: false
    t.string   "table",         limit: 150, default: "", null: false
    t.integer  "key",           limit: 4,   default: 0,  null: false
    t.string   "field",         limit: 150, default: "", null: false
    t.string   "old_value_str", limit: 255, default: "", null: false
    t.string   "new_value_str", limit: 255, default: "", null: false
    t.string   "laatija",       limit: 50,  default: "", null: false
    t.datetime "luontiaika",                             null: false
  end

  add_index "changelog", ["yhtio", "table", "field", "luontiaika"], name: "yhtio_table_field_luontiaika", using: :btree
  add_index "changelog", ["yhtio", "table", "key", "field", "luontiaika"], name: "yhtio_table_key_field_luontiaika", using: :btree

  create_table "customers_users", id: false, force: :cascade do |t|
    t.integer "user_id",     limit: 4, null: false
    t.integer "customer_id", limit: 4, null: false
  end

  add_index "customers_users", ["customer_id"], name: "index_customers_users_on_customer_id", using: :btree
  add_index "customers_users", ["user_id"], name: "index_customers_users_on_user_id", using: :btree

  create_table "directdebit", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",                  limit: 5,     default: "", null: false
    t.string   "rahalaitos",             limit: 20,    default: "", null: false
    t.string   "nimitys",                limit: 50,    default: "", null: false
    t.string   "palvelutunnus",          limit: 35,    default: "", null: false
    t.string   "suoraveloitusmandaatti", limit: 50,    default: "", null: false
    t.text     "teksti_fi",              limit: 65535
    t.text     "teksti_en",              limit: 65535
    t.text     "teksti_se",              limit: 65535
    t.string   "muuttaja",               limit: 50,    default: "", null: false
    t.string   "laatija",                limit: 50,    default: "", null: false
    t.datetime "luontiaika",                                        null: false
    t.datetime "muutospvm",                                         null: false
  end

  create_table "directdebit_asiakas", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",          limit: 5,  default: "", null: false
    t.integer  "liitostunnus",   limit: 4,  default: 0,  null: false
    t.integer  "directdebit_id", limit: 4
    t.string   "valtuutus_id",   limit: 35, default: "", null: false
    t.date     "valtuutus_pvm",                          null: false
    t.string   "maksajan_iban",  limit: 35, default: "", null: false
    t.string   "maksajan_swift", limit: 11, default: "", null: false
    t.string   "muuttaja",       limit: 50, default: "", null: false
    t.string   "laatija",        limit: 50, default: "", null: false
    t.datetime "luontiaika",                             null: false
    t.datetime "muutospvm",                              null: false
  end

  create_table "downloads", force: :cascade do |t|
    t.integer  "user_id",     limit: 4
    t.string   "report_name", limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "downloads", ["user_id"], name: "index_downloads_on_user_id", using: :btree

  create_table "dynaaminen_puu", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",             limit: 5,   default: "", null: false
    t.string   "nimi",              limit: 120, default: "", null: false
    t.string   "nimi_en",           limit: 120, default: "", null: false
    t.integer  "koodi",             limit: 4,   default: 0,  null: false
    t.integer  "toimittajan_koodi", limit: 4,   default: 0,  null: false
    t.integer  "lft",               limit: 4,                null: false
    t.integer  "rgt",               limit: 4,                null: false
    t.string   "laji",              limit: 30,  default: "", null: false
    t.integer  "children_count",    limit: 4,   default: 0,  null: false
    t.integer  "parent_id",         limit: 4
    t.integer  "syvyys",            limit: 4,   default: 0,  null: false
    t.string   "laatija",           limit: 50,  default: "", null: false
    t.datetime "luontiaika",                                 null: false
    t.datetime "muutospvm",                                  null: false
    t.string   "muuttaja",          limit: 50,  default: "", null: false
  end

  add_index "dynaaminen_puu", ["parent_id"], name: "index_dynaaminen_puu_on_parent_id", using: :btree
  add_index "dynaaminen_puu", ["yhtio", "laji", "koodi"], name: "yhtio_laji_koodi", using: :btree
  add_index "dynaaminen_puu", ["yhtio", "laji", "lft"], name: "yhtio_laji_lft", using: :btree
  add_index "dynaaminen_puu", ["yhtio", "laji", "rgt"], name: "yhtio_laji_rgt", using: :btree

  create_table "dynaaminen_puu_avainsanat", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",        limit: 5,     default: "", null: false
    t.integer  "liitostunnus", limit: 4,     default: 0,  null: false
    t.string   "kieli",        limit: 2,     default: "", null: false
    t.string   "laji",         limit: 150,   default: "", null: false
    t.text     "avainsana",    limit: 65535
    t.text     "tarkenne",     limit: 65535
    t.string   "muuttaja",     limit: 50,    default: "", null: false
    t.string   "laatija",      limit: 50,    default: "", null: false
    t.datetime "luontiaika",                              null: false
    t.datetime "muutospvm",                               null: false
  end

  add_index "dynaaminen_puu_avainsanat", ["yhtio", "laji"], name: "yhtio_laji", using: :btree
  add_index "dynaaminen_puu_avainsanat", ["yhtio", "liitostunnus"], name: "yhtio_liitostunnus", using: :btree

  create_table "etaisyydet", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",           limit: 5,  default: "", null: false
    t.string   "varasto_postino", limit: 15, default: "", null: false
    t.string   "postino",         limit: 15, default: "", null: false
    t.string   "postitp",         limit: 35, default: "", null: false
    t.integer  "km",              limit: 4,  default: 0,  null: false
    t.string   "laatija",         limit: 50, default: "", null: false
    t.datetime "luontiaika",                              null: false
    t.datetime "muutospvm",                               null: false
    t.string   "muuttaja",        limit: 50, default: "", null: false
  end

  create_table "extranet_kayttajan_lisatiedot", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",        limit: 5,     default: "", null: false
    t.string   "laji",         limit: 20,    default: "", null: false
    t.integer  "liitostunnus", limit: 4,     default: 0,  null: false
    t.string   "selite",       limit: 50,    default: "", null: false
    t.text     "selitetark",   limit: 65535
    t.string   "laatija",      limit: 50,    default: "", null: false
    t.datetime "luontiaika",                              null: false
    t.string   "muuttaja",     limit: 50,    default: "", null: false
    t.datetime "muutospvm",                               null: false
  end

  add_index "extranet_kayttajan_lisatiedot", ["yhtio", "laji", "selite"], name: "yhtio_laji_selite", using: :btree
  add_index "extranet_kayttajan_lisatiedot", ["yhtio", "liitostunnus", "laji", "selite"], name: "yhtio_liitostunnus_laji_selite", unique: true, using: :btree

  create_table "factoring", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",          limit: 5,     default: "", null: false
    t.string   "factoringyhtio", limit: 10,    default: "", null: false
    t.string   "nimitys",        limit: 55,    default: "", null: false
    t.string   "pankkinimi1",    limit: 80,    default: "", null: false
    t.string   "pankkitili1",    limit: 80,    default: "", null: false
    t.string   "pankkiiban1",    limit: 80,    default: "", null: false
    t.string   "pankkiswift1",   limit: 80,    default: "", null: false
    t.string   "pankkinimi2",    limit: 80,    default: "", null: false
    t.string   "pankkitili2",    limit: 80,    default: "", null: false
    t.string   "pankkiiban2",    limit: 80,    default: "", null: false
    t.string   "pankkiswift2",   limit: 80,    default: "", null: false
    t.string   "pankki_tili",    limit: 35,    default: "", null: false
    t.text     "teksti_fi",      limit: 65535
    t.text     "teksti_en",      limit: 65535
    t.text     "teksti_se",      limit: 65535
    t.text     "teksti_ee",      limit: 65535
    t.string   "sopimusnumero",  limit: 20,    default: "", null: false
    t.string   "email",          limit: 100,   default: "", null: false
    t.string   "valkoodi",       limit: 3,     default: "", null: false
    t.string   "viitetyyppi",    limit: 1,     default: "", null: false
    t.string   "laatija",        limit: 50,    default: "", null: false
    t.datetime "luontiaika",                                null: false
    t.datetime "muutospvm",                                 null: false
    t.string   "muuttaja",       limit: 50,    default: "", null: false
  end

  create_table "files", force: :cascade do |t|
    t.integer  "download_id", limit: 4
    t.string   "filename",    limit: 255
    t.binary   "data",        limit: 4294967295
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "files", ["download_id"], name: "index_files_on_download_id", using: :btree

  create_table "fixed_assets_commodities", force: :cascade do |t|
    t.integer  "company_id",                      limit: 4
    t.integer  "profit_account_id",               limit: 4
    t.integer  "sales_account_id",                limit: 4
    t.integer  "voucher_id",                      limit: 4
    t.datetime "created_at",                                                                         null: false
    t.datetime "updated_at",                                                                         null: false
    t.date     "activated_at"
    t.date     "deactivated_at"
    t.string   "name",                            limit: 255
    t.string   "description",                     limit: 255
    t.string   "status",                          limit: 1
    t.string   "planned_depreciation_type",       limit: 1
    t.decimal  "planned_depreciation_amount",                 precision: 16, scale: 6
    t.string   "btl_depreciation_type",           limit: 1
    t.decimal  "btl_depreciation_amount",                     precision: 16, scale: 6
    t.decimal  "amount",                                      precision: 16, scale: 6
    t.decimal  "amount_sold",                                 precision: 16, scale: 6
    t.decimal  "previous_btl_depreciations",                  precision: 16, scale: 6, default: 0.0
    t.decimal  "transferred_procurement_amount",              precision: 16, scale: 6, default: 0.0
    t.string   "depreciation_remainder_handling", limit: 1
    t.string   "created_by",                      limit: 255
    t.string   "modified_by",                     limit: 255
  end

  add_index "fixed_assets_commodities", ["company_id"], name: "index_fixed_assets_commodities_on_company_id", using: :btree

  create_table "fixed_assets_commodity_rows", force: :cascade do |t|
    t.integer  "commodity_id",  limit: 4
    t.datetime "created_at",                                                         null: false
    t.datetime "updated_at",                                                         null: false
    t.date     "transacted_at"
    t.decimal  "amount",                    precision: 16, scale: 6
    t.string   "description",   limit: 255
    t.boolean  "amended",                                            default: false, null: false
    t.boolean  "locked",                                             default: false, null: false
    t.string   "created_by",    limit: 255
    t.string   "modified_by",   limit: 255
  end

  add_index "fixed_assets_commodity_rows", ["commodity_id"], name: "index_fixed_assets_commodity_rows_on_commodity_id", using: :btree

  create_table "git_paivitykset", force: :cascade do |t|
    t.string   "hash_pupesoft", limit: 50, default: "",         null: false
    t.string   "hash_pupenext", limit: 50, default: "",         null: false
    t.string   "repository",    limit: 20, default: "pupesoft", null: false
    t.string   "ip",            limit: 15,                      null: false
    t.datetime "date",                                          null: false
  end

  create_table "git_pulkkarit", force: :cascade do |t|
    t.string   "repository",   limit: 20,    default: "pupesoft", null: false
    t.datetime "updated",                                         null: false
    t.datetime "merged",                                          null: false
    t.integer  "feature",      limit: 4,     default: 0,          null: false
    t.text     "pull_request", limit: 65535
    t.text     "files",        limit: 65535
  end

  create_table "hinnasto", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",                 limit: 5,                            default: "",  null: false
    t.string   "tuoteno",               limit: 60,                           default: "",  null: false
    t.integer  "minkpl",                limit: 4,                            default: 0,   null: false
    t.integer  "maxkpl",                limit: 4,                            default: 0,   null: false
    t.decimal  "hinta",                             precision: 16, scale: 6, default: 0.0, null: false
    t.date     "alkupvm",                                                                  null: false
    t.date     "loppupvm",                                                                 null: false
    t.string   "laji",                  limit: 1,                            default: "",  null: false
    t.string   "maa",                   limit: 2,                            default: "",  null: false
    t.string   "valkoodi",              limit: 3,                            default: "",  null: false
    t.decimal  "alv",                               precision: 5,  scale: 2, default: 0.0, null: false
    t.string   "selite",                limit: 100,                          default: "",  null: false
    t.integer  "yhtion_toimipaikka_id", limit: 4
    t.integer  "campaign_id",           limit: 4
    t.string   "laatija",               limit: 50,                           default: "",  null: false
    t.datetime "luontiaika",                                                               null: false
    t.datetime "muutospvm",                                                                null: false
    t.string   "muuttaja",              limit: 50,                           default: "",  null: false
  end

  add_index "hinnasto", ["yhtio", "tuoteno"], name: "yhtio_tuoteno", using: :btree
  add_index "hinnasto", ["yhtion_toimipaikka_id"], name: "index_hinnasto_on_yhtion_toimipaikka_id", using: :btree

  create_table "hyvaksyttavat_dokumentit", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",             limit: 5,   default: "",  null: false
    t.string   "nimi",              limit: 150, default: "",  null: false
    t.text     "kuvaus",            limit: 255
    t.text     "kommentit",         limit: 255
    t.string   "tila",              limit: 2,   default: "0", null: false
    t.string   "hyvak1",            limit: 50,  default: "",  null: false
    t.datetime "h1time",                                      null: false
    t.string   "hyvak2",            limit: 50,  default: "",  null: false
    t.datetime "h2time",                                      null: false
    t.string   "hyvak3",            limit: 50,  default: "",  null: false
    t.datetime "h3time",                                      null: false
    t.string   "hyvak4",            limit: 50,  default: "",  null: false
    t.datetime "h4time",                                      null: false
    t.string   "hyvak5",            limit: 50,  default: "",  null: false
    t.datetime "h5time",                                      null: false
    t.string   "hyvaksyja_nyt",     limit: 50,  default: "",  null: false
    t.string   "hyvaksynnanmuutos", limit: 1,   default: "",  null: false
    t.string   "laatija",           limit: 50,  default: "",  null: false
    t.datetime "luontiaika",                                  null: false
    t.string   "muuttaja",          limit: 50,  default: "",  null: false
    t.datetime "muutospvm",                                   null: false
  end

  add_index "hyvaksyttavat_dokumentit", ["yhtio", "tila"], name: "yhtio_tila", using: :btree

  create_table "hyvityssaannot", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",             limit: 5,                           default: "",  null: false
    t.string   "rokotusselite",     limit: 100,                         default: "",  null: false
    t.string   "tuote_kentta",      limit: 30,                          default: "",  null: false
    t.string   "tuote_arvo",        limit: 100,                         default: "",  null: false
    t.string   "asiakas_kentta",    limit: 40,                          default: "",  null: false
    t.string   "asiakas_arvo",      limit: 100,                         default: "",  null: false
    t.integer  "asiakas_segmentti", limit: 4,                           default: 0,   null: false
    t.integer  "aika_ostosta",      limit: 4,                           default: 0,   null: false
    t.decimal  "rokotusprosentti",              precision: 5, scale: 2, default: 0.0, null: false
    t.string   "palautuskielto",    limit: 1,                           default: "",  null: false
    t.integer  "prioriteetti",      limit: 4,                           default: 0,   null: false
    t.string   "laatija",           limit: 50,                          default: "",  null: false
    t.datetime "luontiaika",                                                          null: false
    t.datetime "muutospvm",                                                           null: false
    t.string   "muuttaja",          limit: 50,                          default: "",  null: false
  end

  add_index "hyvityssaannot", ["yhtio", "aika_ostosta"], name: "yhtio_aika_ostosta", using: :btree
  add_index "hyvityssaannot", ["yhtio", "tuote_kentta", "tuote_arvo"], name: "yhtio_tuote_kentta_tuote_arvo", using: :btree

  create_table "incoming_mails", force: :cascade do |t|
    t.text     "raw_source",     limit: 4294967295
    t.integer  "mail_server_id", limit: 4
    t.datetime "processed_at"
    t.integer  "status",         limit: 4
    t.text     "status_message", limit: 65535
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "incoming_mails", ["mail_server_id"], name: "index_incoming_mails_on_mail_server_id", using: :btree

  create_table "inventointilista", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",        limit: 5,     default: "", null: false
    t.string   "naytamaara",   limit: 1,     default: "", null: false
    t.text     "vapaa_teksti", limit: 65535,              null: false
    t.string   "muuttaja",     limit: 50,    default: "", null: false
    t.string   "laatija",      limit: 50,    default: "", null: false
    t.datetime "luontiaika"
    t.datetime "muutospvm"
  end

  create_table "inventointilistarivi", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",             limit: 5,                           default: "",  null: false
    t.string   "tila",              limit: 1,                           default: "",  null: false
    t.integer  "otunnus",           limit: 4,                           default: 0,   null: false
    t.string   "tuoteno",           limit: 60,                          default: "",  null: false
    t.string   "hyllyalue",         limit: 5,                           default: "",  null: false
    t.string   "hyllynro",          limit: 5,                           default: "",  null: false
    t.string   "hyllyvali",         limit: 5,                           default: "",  null: false
    t.string   "hyllytaso",         limit: 5,                           default: "",  null: false
    t.datetime "aika"
    t.integer  "rivinro",           limit: 4,                           default: 0,   null: false
    t.decimal  "hyllyssa",                     precision: 12, scale: 2, default: 0.0, null: false
    t.decimal  "laskettu",                     precision: 12, scale: 2
    t.integer  "tuotepaikkatunnus", limit: 4,                           default: 0,   null: false
    t.integer  "tapahtumatunnus",   limit: 4,                           default: 0,   null: false
    t.string   "muuttaja",          limit: 50,                          default: "",  null: false
    t.string   "laatija",           limit: 50,                          default: "",  null: false
    t.datetime "luontiaika"
    t.datetime "muutospvm"
  end

  add_index "inventointilistarivi", ["yhtio", "otunnus", "tuoteno"], name: "index_inventointilistarivi_on_yhtio_and_otunnus_and_tuoteno", using: :btree
  add_index "inventointilistarivi", ["yhtio", "tuotepaikkatunnus"], name: "tuotepaikkatunnus", using: :btree

  create_table "kalenteri", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",           limit: 5,     default: "",                    null: false
    t.string   "konserni",        limit: 5,     default: "",                    null: false
    t.string   "kuka",            limit: 50,    default: "",                    null: false
    t.string   "myyntipaallikko", limit: 10,    default: "",                    null: false
    t.string   "laatija",         limit: 50,    default: "",                    null: false
    t.datetime "luontiaika",                                                    null: false
    t.datetime "muutospvm",                                                     null: false
    t.string   "muuttaja",        limit: 50,    default: "",                    null: false
    t.string   "asiakas",         limit: 15,    default: "",                    null: false
    t.integer  "henkilo",         limit: 8,     default: 0,                     null: false
    t.string   "tapa",            limit: 25,    default: "",                    null: false
    t.string   "kuittaus",        limit: 50,    default: "",                    null: false
    t.datetime "pvmalku",                                                       null: false
    t.datetime "pvmloppu",                                                      null: false
    t.time     "aikaalku",                      default: '2000-01-01 00:00:00', null: false
    t.time     "aikaloppu",                     default: '2000-01-01 00:00:00', null: false
    t.string   "tyyppi",          limit: 50,    default: "",                    null: false
    t.string   "kieli",           limit: 2,     default: "",                    null: false
    t.string   "kokopaiva",       limit: 1,     default: "",                    null: false
    t.text     "kentta01",        limit: 65535
    t.text     "kentta02",        limit: 65535
    t.text     "kentta03",        limit: 65535
    t.text     "kentta04",        limit: 65535
    t.text     "kentta05",        limit: 65535
    t.text     "kentta06",        limit: 65535
    t.text     "kentta07",        limit: 65535
    t.text     "kentta08",        limit: 65535
    t.text     "kentta09",        limit: 65535
    t.text     "kentta10",        limit: 65535
    t.integer  "liitostunnus",    limit: 4,     default: 0,                     null: false
    t.integer  "otunnus",         limit: 4,     default: 0,                     null: false
    t.integer  "perheid",         limit: 4,     default: 0,                     null: false
  end

  add_index "kalenteri", ["yhtio", "kuka", "tyyppi", "pvmalku"], name: "yhtio_kuka_tyyppi_pvmalku", using: :btree
  add_index "kalenteri", ["yhtio", "liitostunnus"], name: "yhtio_liitostunnus", using: :btree
  add_index "kalenteri", ["yhtio", "tyyppi", "pvmalku"], name: "yhtio_tyyppi_pvmalku", using: :btree
  add_index "kalenteri", ["yhtio", "tyyppi", "tapa", "pvmalku"], name: "tyyppi_tapa", using: :btree

  create_table "kampanja_ehdot", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",      limit: 5,  default: "", null: false
    t.integer  "kampanja",   limit: 4,  default: 0,  null: false
    t.integer  "isatunnus",  limit: 4,  default: 0,  null: false
    t.string   "kohde",      limit: 20, default: "", null: false
    t.string   "rajoitin",   limit: 20, default: "", null: false
    t.string   "arvo",       limit: 20, default: "", null: false
    t.string   "laatija",    limit: 50, default: "", null: false
    t.datetime "luontiaika",                         null: false
    t.datetime "muutospvm",                          null: false
    t.string   "muuttaja",   limit: 50, default: "", null: false
  end

  create_table "kampanja_palkinnot", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",      limit: 5,  default: "", null: false
    t.integer  "kampanja",   limit: 4,  default: 0,  null: false
    t.string   "tuoteno",    limit: 60, default: "", null: false
    t.integer  "kpl",        limit: 4,  default: 0,  null: false
    t.string   "laatija",    limit: 50, default: "", null: false
    t.datetime "luontiaika",                         null: false
    t.datetime "muutospvm",                          null: false
    t.string   "muuttaja",   limit: 50, default: "", null: false
  end

  create_table "kampanjat", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",      limit: 5,   default: "", null: false
    t.string   "nimi",       limit: 255, default: "", null: false
    t.string   "laatija",    limit: 50,  default: "", null: false
    t.datetime "luontiaika",                          null: false
    t.datetime "muutospvm",                           null: false
    t.string   "muuttaja",   limit: 50,  default: "", null: false
  end

  create_table "karhu_lasku", id: false, force: :cascade do |t|
    t.integer "ktunnus", limit: 4, default: 0, null: false
    t.integer "ltunnus", limit: 4, default: 0, null: false
  end

  add_index "karhu_lasku", ["ktunnus"], name: "ktunnus", using: :btree
  add_index "karhu_lasku", ["ltunnus"], name: "ltunnus", using: :btree

  create_table "karhukierros", primary_key: "tunnus", force: :cascade do |t|
    t.string "tyyppi", limit: 1, default: "", null: false
    t.date   "pvm",                           null: false
    t.string "yhtio",  limit: 5, default: "", null: false
  end

  create_table "kassalipas", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",         limit: 5,   default: "", null: false
    t.string   "nimi",          limit: 150, default: "", null: false
    t.integer  "kustp",         limit: 4,   default: 0,  null: false
    t.integer  "toimipaikka",   limit: 4,   default: 0,  null: false
    t.string   "email",         limit: 100, default: "", null: false
    t.string   "kassa",         limit: 6,   default: "", null: false
    t.string   "pankkikortti",  limit: 6,   default: "", null: false
    t.string   "luottokortti",  limit: 6,   default: "", null: false
    t.string   "kateistilitys", limit: 6,   default: "", null: false
    t.string   "kassaerotus",   limit: 6,   default: "", null: false
    t.string   "kateisotto",    limit: 6,   default: "", null: false
    t.string   "laatija",       limit: 50,  default: "", null: false
    t.datetime "luontiaika",                             null: false
    t.datetime "muutospvm",                              null: false
    t.string   "muuttaja",      limit: 50,  default: "", null: false
  end

  create_table "kerattavatrivit", force: :cascade do |t|
    t.integer  "tilausrivi_id",       limit: 4
    t.string   "hyllyalue",           limit: 255
    t.string   "hyllynro",            limit: 255
    t.string   "hyllyvali",           limit: 255
    t.string   "hyllytaso",           limit: 255
    t.decimal  "poikkeava_maara",                 precision: 10
    t.string   "poikkeama_kasittely", limit: 255
    t.boolean  "keratty"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
  end

  add_index "kerattavatrivit", ["tilausrivi_id"], name: "tilausrivi_id_index", unique: true, using: :btree

  create_table "kerayserat", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",          limit: 5,                            default: "",  null: false
    t.integer  "nro",            limit: 4,                            default: 0,   null: false
    t.integer  "keraysvyohyke",  limit: 4,                            default: 0,   null: false
    t.string   "tila",           limit: 1,                            default: "",  null: false
    t.integer  "sscc",           limit: 4,                            default: 0,   null: false
    t.string   "sscc_ulkoinen",  limit: 150,                          default: "",  null: false
    t.integer  "otunnus",        limit: 4,                            default: 0,   null: false
    t.integer  "tilausrivi",     limit: 4,                            default: 0,   null: false
    t.integer  "pakkaus",        limit: 4,                            default: 0,   null: false
    t.integer  "pakkausnro",     limit: 4,                            default: 0,   null: false
    t.decimal  "kpl",                        precision: 12, scale: 2, default: 0.0, null: false
    t.decimal  "kpl_keratty",                precision: 12, scale: 2, default: 0.0, null: false
    t.string   "keratty",        limit: 50,                           default: "",  null: false
    t.datetime "kerattyaika",                                                       null: false
    t.string   "laatija",        limit: 50,                           default: "",  null: false
    t.datetime "luontiaika",                                                        null: false
    t.datetime "muutospvm",                                                         null: false
    t.string   "muuttaja",       limit: 50,                           default: "",  null: false
    t.string   "ohjelma_moduli", limit: 50,                           default: "",  null: false
  end

  add_index "kerayserat", ["yhtio", "nro", "tila", "laatija"], name: "yhtio_nro_tila_laatija", using: :btree
  add_index "kerayserat", ["yhtio", "nro"], name: "yhtio_nro", using: :btree
  add_index "kerayserat", ["yhtio", "otunnus"], name: "yhtio_otunnus", using: :btree
  add_index "kerayserat", ["yhtio", "sscc"], name: "yhtio_sscc", using: :btree
  add_index "kerayserat", ["yhtio", "sscc_ulkoinen"], name: "yhtio_sscculkoinen", using: :btree
  add_index "kerayserat", ["yhtio", "tila", "laatija"], name: "yhtio_tila_laatija", using: :btree
  add_index "kerayserat", ["yhtio", "tilausrivi"], name: "yhtio_tilausrivi", using: :btree

  create_table "keraysvyohyke", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",                                  limit: 5,                            default: "",  null: false
    t.string   "nimitys",                                limit: 100,                          default: "",  null: false
    t.string   "sallitut_alustat",                       limit: 150,                          default: "",  null: false
    t.integer  "varasto",                                limit: 4,                            default: 0,   null: false
    t.string   "printteri0",                             limit: 20,                           default: "",  null: false
    t.string   "printteri1",                             limit: 20,                           default: "",  null: false
    t.string   "printteri3",                             limit: 20,                           default: "",  null: false
    t.string   "printteri8",                             limit: 20,                           default: "",  null: false
    t.decimal  "max_keraysera_pintaala",                             precision: 10, scale: 2, default: 0.0, null: false
    t.integer  "max_keraysera_rivit",                    limit: 4,                            default: 0,   null: false
    t.integer  "max_keraysera_alustat",                  limit: 4,                            default: 0,   null: false
    t.string   "keraysjarjestys",                        limit: 1,                            default: "",  null: false
    t.string   "terminaalialue",                         limit: 150,                          default: "",  null: false
    t.integer  "lahtojen_valinen_enimmaisaika",          limit: 4,                            default: 0,   null: false
    t.decimal  "tilauksen_tyoaikavakio_min_per_tilaus",              precision: 12, scale: 2, default: 0.0, null: false
    t.decimal  "kerailyrivin_tyoaikavakio_min_per_rivi",             precision: 12, scale: 2, default: 0.0, null: false
    t.string   "ulkoinen_jarjestelma",                   limit: 1,                            default: "",  null: false
    t.string   "yhdistelysaanto",                        limit: 5,                            default: "",  null: false
    t.string   "keraysnippujen_priorisointi",            limit: 1,                            default: "",  null: false
    t.decimal  "aikaraja",                                           precision: 5,  scale: 2, default: 0.0, null: false
    t.decimal  "mittaraja",                                          precision: 10, scale: 2, default: 0.0, null: false
    t.decimal  "painoraja",                                          precision: 10, scale: 2, default: 0.0, null: false
    t.decimal  "kappaleraja",                                        precision: 12, scale: 2, default: 0.0, null: false
    t.string   "laatija",                                limit: 50,                           default: "",  null: false
    t.datetime "luontiaika",                                                                                null: false
    t.datetime "muutospvm",                                                                                 null: false
    t.string   "muuttaja",                               limit: 50,                           default: "",  null: false
  end

  add_index "keraysvyohyke", ["yhtio"], name: "yhtio", using: :btree

  create_table "kirjoittimet", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",         limit: 5,   default: "", null: false
    t.string   "kirjoitin",     limit: 100, default: "", null: false
    t.string   "komento",       limit: 150, default: "", null: false
    t.string   "unifaun_nimi",  limit: 150, default: "", null: false
    t.integer  "merkisto",      limit: 4,   default: 0,  null: false
    t.string   "mediatyyppi",   limit: 100, default: "", null: false
    t.string   "nimi",          limit: 60,  default: "", null: false
    t.string   "osoite",        limit: 30,  default: "", null: false
    t.string   "postino",       limit: 15,  default: "", null: false
    t.string   "postitp",       limit: 10,  default: "", null: false
    t.string   "puhelin",       limit: 20,  default: "", null: false
    t.string   "yhteyshenkilo", limit: 100, default: "", null: false
    t.string   "ip",            limit: 15,  default: "", null: false
    t.integer  "jarjestys",     limit: 4,   default: 0,  null: false
    t.string   "laatija",       limit: 50,  default: "", null: false
    t.datetime "luontiaika",                             null: false
    t.datetime "muutospvm",                              null: false
    t.string   "muuttaja",      limit: 50,  default: "", null: false
  end

  create_table "kohde", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",         limit: 5,     default: "",    null: false
    t.integer  "asiakas",       limit: 4,     default: 0,     null: false
    t.string   "nimi",          limit: 60,    default: "",    null: false
    t.string   "nimitark",      limit: 60,    default: "",    null: false
    t.string   "tyyppi",        limit: 150,   default: "",    null: false
    t.string   "osoite",        limit: 60,    default: "",    null: false
    t.string   "osoitetark",    limit: 60,    default: "",    null: false
    t.string   "postitp",       limit: 60,    default: "",    null: false
    t.string   "postino",       limit: 60,    default: "",    null: false
    t.string   "paikkakunta",   limit: 60,    default: "",    null: false
    t.string   "email",         limit: 60,    default: "",    null: false
    t.string   "puhelin",       limit: 20,    default: "",    null: false
    t.string   "fax",           limit: 20,    default: "",    null: false
    t.string   "yhteyshlo",     limit: 60,    default: "",    null: false
    t.string   "vastuuhenkilo", limit: 50,    default: "",    null: false
    t.string   "kayntiohje",    limit: 150,   default: "",    null: false
    t.text     "kommentti",     limit: 65535
    t.boolean  "poistettu",                   default: false, null: false
    t.string   "laatija",       limit: 50,    default: "",    null: false
    t.datetime "luontiaika",                                  null: false
    t.datetime "muutospvm",                                   null: false
    t.string   "muuttaja",      limit: 50,    default: "",    null: false
  end

  add_index "kohde", ["yhtio", "asiakas"], name: "yhtio_asiakas", using: :btree

  create_table "korvaavat", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",      limit: 5,  default: "", null: false
    t.integer  "jarjestys",  limit: 8,  default: 0,  null: false
    t.string   "tuoteno",    limit: 60, default: "", null: false
    t.integer  "id",         limit: 8,  default: 0,  null: false
    t.string   "laatija",    limit: 50, default: "", null: false
    t.datetime "luontiaika",                         null: false
    t.datetime "muutospvm",                          null: false
    t.string   "muuttaja",   limit: 50, default: "", null: false
  end

  add_index "korvaavat", ["yhtio", "id"], name: "yhtio_id", using: :btree
  add_index "korvaavat", ["yhtio", "tuoteno"], name: "yhtio_tuoteno", using: :btree

  create_table "korvaavat_kiellot", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",      limit: 5,  default: "", null: false
    t.string   "ytunnus",    limit: 15, default: "", null: false
    t.string   "osasto",     limit: 2,  default: "", null: false
    t.string   "try",        limit: 5,  default: "", null: false
    t.string   "laji",       limit: 1,  default: "", null: false
    t.string   "laatija",    limit: 50, default: "", null: false
    t.datetime "luontiaika",                         null: false
    t.datetime "muutospvm",                          null: false
    t.string   "muuttaja",   limit: 50, default: "", null: false
  end

  create_table "kuka", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",                         limit: 5,                              default: "",  null: false
    t.string   "kuka",                          limit: 50,                             default: "",  null: false
    t.text     "nimi",                          limit: 65535
    t.string   "salasana",                      limit: 50,                             default: "",  null: false
    t.string   "ip",                            limit: 15,                             default: "",  null: false
    t.text     "profiilit",                     limit: 65535
    t.text     "piirit",                        limit: 65535
    t.string   "naytetaan_katteet_tilauksella", limit: 1,                              default: "",  null: false
    t.string   "naytetaan_asiakashinta",        limit: 1,                              default: "",  null: false
    t.string   "naytetaan_tuotteet",            limit: 1,                              default: "",  null: false
    t.string   "naytetaan_tilaukset",           limit: 1,                              default: "",  null: false
    t.string   "jyvitys",                       limit: 1,                              default: "",  null: false
    t.string   "hyvaksyja",                     limit: 1,                              default: "",  null: false
    t.integer  "hyvaksyja_maksimisumma",        limit: 4,                              default: 0,   null: false
    t.string   "hierarkia",                     limit: 150,                            default: "",  null: false
    t.string   "extranet",                      limit: 1,                              default: "",  null: false
    t.string   "kayttoliittyma",                limit: 1,                              default: "",  null: false
    t.string   "oletus_ohjelma",                limit: 150,                            default: "",  null: false
    t.integer  "maksuehto",                     limit: 4,                              default: 0,   null: false
    t.string   "toimitustapa",                  limit: 50,                             default: "",  null: false
    t.string   "eilahetetta",                   limit: 1,                              default: "",  null: false
    t.string   "oletus_asiakas",                limit: 25,                             default: "",  null: false
    t.string   "oletus_asiakastiedot",          limit: 25,                             default: "",  null: false
    t.string   "oletus_profiili",               limit: 150,                            default: "",  null: false
    t.string   "kassamyyja",                    limit: 150,                            default: "",  null: false
    t.string   "kassalipas_otto",               limit: 255,                            default: "",  null: false
    t.integer  "kirjoitin",                     limit: 4,                              default: 0,   null: false
    t.integer  "kuittitulostin",                limit: 4,                              default: 0,   null: false
    t.integer  "lahetetulostin",                limit: 4,                              default: 0,   null: false
    t.integer  "rahtikirjatulostin",            limit: 4,                              default: 0,   null: false
    t.string   "varasto",                       limit: 150,                            default: "",  null: false
    t.integer  "oletus_varasto",                limit: 4,                              default: 0,   null: false
    t.integer  "oletus_ostovarasto",            limit: 4,                              default: 0,   null: false
    t.string   "oletus_pakkaamo",               limit: 150,                            default: "",  null: false
    t.string   "fyysinen_sijainti",             limit: 150,                            default: "",  null: false
    t.string   "keraysvyohyke",                 limit: 150,                            default: "",  null: false
    t.integer  "max_keraysera_alustat",         limit: 4,                              default: 0,   null: false
    t.integer  "saatavat",                      limit: 4,                              default: 0,   null: false
    t.integer  "hinnat",                        limit: 4,                              default: 0,   null: false
    t.string   "kulujen_laskeminen_hintoihin",  limit: 1,                              default: "",  null: false
    t.integer  "taso",                          limit: 4,                              default: 0,   null: false
    t.integer  "kesken",                        limit: 4,                              default: 0,   null: false
    t.datetime "lastlogin",                                                                          null: false
    t.integer  "keraajanro",                    limit: 4,                              default: 0,   null: false
    t.string   "osasto",                        limit: 70,                             default: "",  null: false
    t.integer  "myyja",                         limit: 4,                              default: 0,   null: false
    t.string   "oletustili",                    limit: 6,                              default: "",  null: false
    t.integer  "myyjaryhma",                    limit: 4,                              default: 0,   null: false
    t.string   "tuuraaja",                      limit: 50,                             default: "",  null: false
    t.string   "kieli",                         limit: 2,                              default: "",  null: false
    t.integer  "lomaoikeus",                    limit: 4,                              default: 0,   null: false
    t.string   "asema",                         limit: 150,                            default: "",  null: false
    t.string   "dynaaminen_kassamyynti",        limit: 1,                              default: "",  null: false
    t.string   "maksupaate_kassamyynti",        limit: 1,                              default: "",  null: false
    t.string   "maksupaate_ip",                 limit: 60,                             default: "",  null: false
    t.integer  "toimipaikka",                   limit: 4,                              default: 0,   null: false
    t.string   "eposti",                        limit: 50,                             default: "",  null: false
    t.string   "puhno",                         limit: 30,                             default: "",  null: false
    t.string   "tilaus_valmis",                 limit: 1,                              default: "",  null: false
    t.string   "mitatoi_tilauksia",             limit: 1,                              default: "",  null: false
    t.string   "session",                       limit: 32,                             default: "",  null: false
    t.string   "api_key",                       limit: 100,                            default: "",  null: false
    t.decimal  "budjetti",                                    precision: 12, scale: 2, default: 0.0, null: false
    t.integer  "aktiivinen",                    limit: 4,                              default: 0,   null: false
    t.string   "laatija",                       limit: 50,                             default: "",  null: false
    t.datetime "luontiaika",                                                                         null: false
    t.datetime "muutospvm",                                                                          null: false
    t.string   "muuttaja",                      limit: 50,                             default: "",  null: false
  end

  add_index "kuka", ["session"], name: "session_index", using: :btree
  add_index "kuka", ["yhtio", "aktiivinen", "extranet"], name: "yhtio_aktiivinen_extranet", using: :btree
  add_index "kuka", ["yhtio", "kesken"], name: "yhtio_kesken", using: :btree
  add_index "kuka", ["yhtio", "kuka"], name: "kuka_index", unique: true, using: :btree
  add_index "kuka", ["yhtio", "myyja"], name: "yhtio_myyja", using: :btree

  create_table "kustannuspaikka", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",        limit: 5,  default: "", null: false
    t.string   "tyyppi",       limit: 1,  default: "", null: false
    t.integer  "isa_tarkenne", limit: 4
    t.string   "koodi",        limit: 35, default: "", null: false
    t.string   "nimi",         limit: 35, default: "", null: false
    t.string   "kaytossa",     limit: 1,  default: "", null: false
    t.string   "laatija",      limit: 50, default: "", null: false
    t.datetime "luontiaika",                           null: false
    t.datetime "muutospvm",                            null: false
    t.string   "muuttaja",     limit: 50, default: "", null: false
  end

  create_table "lahdot", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",                limit: 5,   default: "",                    null: false
    t.date     "pvm",                                                              null: false
    t.integer  "lahdon_viikonpvm",     limit: 4,   default: 0,                     null: false
    t.time     "lahdon_kellonaika",                default: '2000-01-01 00:00:00', null: false
    t.time     "viimeinen_tilausaika",             default: '2000-01-01 00:00:00', null: false
    t.time     "kerailyn_aloitusaika",             default: '2000-01-01 00:00:00', null: false
    t.string   "terminaalialue",       limit: 150, default: "",                    null: false
    t.string   "asiakasluokka",        limit: 50,  default: "",                    null: false
    t.string   "vakisin_kerays",       limit: 1,   default: "",                    null: false
    t.string   "aktiivi",              limit: 1,   default: "",                    null: false
    t.string   "ohjausmerkki",         limit: 70,  default: "",                    null: false
    t.integer  "liitostunnus",         limit: 4,   default: 0,                     null: false
    t.integer  "varasto",              limit: 4,   default: 0,                     null: false
    t.string   "laatija",              limit: 50,  default: "",                    null: false
    t.datetime "luontiaika",                                                       null: false
    t.datetime "muutospvm",                                                        null: false
    t.string   "muuttaja",             limit: 50,  default: "",                    null: false
  end

  add_index "lahdot", ["yhtio", "aktiivi", "liitostunnus"], name: "yhtio_aktiivi_liitostunnus", using: :btree
  add_index "lahdot", ["yhtio", "aktiivi", "pvm"], name: "yhtio_aktiivi_pvm", using: :btree

  create_table "laite", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",                              limit: 5,     default: "", null: false
    t.string   "tuoteno",                            limit: 60,    default: "", null: false
    t.string   "sarjanro",                           limit: 60,    default: "", null: false
    t.string   "ponnepullonro",                      limit: 60,    default: "", null: false
    t.date     "valm_pvm",                                                      null: false
    t.string   "oma_numero",                         limit: 20,    default: "", null: false
    t.string   "omistaja",                           limit: 60,    default: "", null: false
    t.integer  "paikka",                             limit: 4,     default: 0,  null: false
    t.string   "sijainti",                           limit: 60,    default: "", null: false
    t.string   "toimipiste",                         limit: 12,    default: "", null: false
    t.string   "ip_osoite",                          limit: 60,    default: "", null: false
    t.string   "mac_osoite",                         limit: 60,    default: "", null: false
    t.string   "lcm_info",                           limit: 60,    default: "", null: false
    t.text     "kommentti",                          limit: 65535
    t.string   "tila",                               limit: 1,     default: "", null: false
    t.integer  "koodi",                              limit: 4,     default: 0,  null: false
    t.integer  "sla",                                limit: 4,     default: 0,  null: false
    t.string   "sd_sla",                             limit: 60,    default: "", null: false
    t.string   "valmistajan_sopimusnumero",          limit: 60,    default: "", null: false
    t.string   "laatija",                            limit: 50,    default: "", null: false
    t.datetime "luontiaika",                                                    null: false
    t.datetime "muutospvm",                                                     null: false
    t.date     "valmistajan_sopimus_paattymispaiva",                            null: false
    t.string   "muuttaja",                           limit: 50,    default: "", null: false
  end

  add_index "laite", ["yhtio", "koodi"], name: "yhtio_koodi", using: :btree
  add_index "laite", ["yhtio", "paikka"], name: "yhtio_paikka", using: :btree

  create_table "laitteen_sopimukset", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",               limit: 5,  default: "", null: false
    t.integer  "laitteen_tunnus",     limit: 4,  default: 0,  null: false
    t.integer  "sopimusrivin_tunnus", limit: 4,  default: 0,  null: false
    t.string   "laatija",             limit: 50, default: "", null: false
    t.datetime "luontiaika",                                  null: false
    t.datetime "muutospvm",                                   null: false
    t.string   "muuttaja",            limit: 50, default: "", null: false
  end

  create_table "lasku", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",                            limit: 5,                              default: "",         null: false
    t.string   "yhtio_nimi",                       limit: 60,                             default: "",         null: false
    t.string   "yhtio_osoite",                     limit: 55,                             default: "",         null: false
    t.string   "yhtio_postino",                    limit: 35,                             default: "",         null: false
    t.string   "yhtio_postitp",                    limit: 35,                             default: "",         null: false
    t.string   "yhtio_maa",                        limit: 35,                             default: "",         null: false
    t.string   "yhtio_ovttunnus",                  limit: 25,                             default: "",         null: false
    t.string   "yhtio_kotipaikka",                 limit: 25,                             default: "",         null: false
    t.integer  "yhtio_toimipaikka",                limit: 4,                              default: 0,          null: false
    t.string   "nimi",                             limit: 60,                             default: "",         null: false
    t.string   "nimitark",                         limit: 60,                             default: "",         null: false
    t.string   "osoite",                           limit: 45,                             default: "",         null: false
    t.string   "osoitetark",                       limit: 45,                             default: "",         null: false
    t.string   "postino",                          limit: 15,                             default: "",         null: false
    t.string   "postitp",                          limit: 45,                             default: "",         null: false
    t.string   "maa",                              limit: 2,                              default: "",         null: false
    t.string   "puh",                              limit: 50,                             default: "",         null: false
    t.string   "email",                            limit: 100,                            default: "",         null: false
    t.string   "toim_nimi",                        limit: 60,                             default: "",         null: false
    t.string   "toim_nimitark",                    limit: 60,                             default: "",         null: false
    t.string   "toim_osoite",                      limit: 55,                             default: "",         null: false
    t.string   "toim_postino",                     limit: 35,                             default: "",         null: false
    t.string   "toim_postitp",                     limit: 35,                             default: "",         null: false
    t.string   "toim_maa",                         limit: 2,                              default: "",         null: false
    t.string   "toim_puh",                         limit: 50,                             default: "",         null: false
    t.string   "toim_email",                       limit: 100,                            default: "",         null: false
    t.string   "pankki_haltija",                   limit: 60,                             default: "",         null: false
    t.string   "tilinumero",                       limit: 14,                             default: "",         null: false
    t.string   "swift",                            limit: 11,                             default: "",         null: false
    t.string   "pankki1",                          limit: 35,                             default: "",         null: false
    t.string   "pankki2",                          limit: 35,                             default: "",         null: false
    t.string   "pankki3",                          limit: 35,                             default: "",         null: false
    t.string   "pankki4",                          limit: 35,                             default: "",         null: false
    t.string   "ultilno_maa",                      limit: 2,                              default: "",         null: false
    t.string   "ultilno",                          limit: 35,                             default: "",         null: false
    t.string   "clearing",                         limit: 35,                             default: "",         null: false
    t.string   "maksutyyppi",                      limit: 1,                              default: "",         null: false
    t.string   "valkoodi",                         limit: 3,                              default: "",         null: false
    t.decimal  "alv",                                            precision: 5,  scale: 2, default: 0.0,        null: false
    t.date     "lapvm",                                                                                        null: false
    t.date     "tapvm",                                                                                        null: false
    t.date     "kapvm",                                                                                        null: false
    t.date     "erpcm",                                                                                        null: false
    t.string   "suoraveloitus",                    limit: 1,                              default: "",         null: false
    t.date     "olmapvm",                                                                                      null: false
    t.date     "toimaika",                                                                                     null: false
    t.string   "toimvko",                          limit: 2,                              default: "",         null: false
    t.datetime "kerayspvm",                                                                                    null: false
    t.string   "keraysvko",                        limit: 2,                              default: "",         null: false
    t.decimal  "summa",                                          precision: 12, scale: 2, default: 0.0,        null: false
    t.decimal  "summa_valuutassa",                               precision: 12, scale: 2, default: 0.0,        null: false
    t.decimal  "kasumma",                                        precision: 12, scale: 2, default: 0.0,        null: false
    t.decimal  "kasumma_valuutassa",                             precision: 12, scale: 2, default: 0.0,        null: false
    t.decimal  "hinta",                                          precision: 12, scale: 2, default: 0.0,        null: false
    t.decimal  "kate",                                           precision: 12, scale: 2, default: 0.0,        null: false
    t.decimal  "kate_korjattu",                                  precision: 12, scale: 2
    t.decimal  "arvo",                                           precision: 12, scale: 2, default: 0.0,        null: false
    t.decimal  "arvo_valuutassa",                                precision: 12, scale: 2, default: 0.0,        null: false
    t.decimal  "saldo_maksettu",                                 precision: 12, scale: 2, default: 0.0,        null: false
    t.decimal  "saldo_maksettu_valuutassa",                      precision: 12, scale: 2, default: 0.0,        null: false
    t.decimal  "pyoristys",                                      precision: 12, scale: 2, default: 0.0,        null: false
    t.decimal  "pyoristys_valuutassa",                           precision: 12, scale: 2, default: 0.0,        null: false
    t.decimal  "pyoristys_erot",                                 precision: 16, scale: 6, default: 0.0,        null: false
    t.decimal  "pyoristys_erot_alv",                             precision: 5,  scale: 2, default: 0.0,        null: false
    t.decimal  "luottoraja",                                     precision: 12, scale: 2, default: 0.0,        null: false
    t.decimal  "erapaivan_ylityksen_summa",                      precision: 12, scale: 2, default: 0.0,        null: false
    t.string   "laatija",                          limit: 50,                             default: "",         null: false
    t.datetime "luontiaika",                                                                                   null: false
    t.string   "maksaja",                          limit: 50,                             default: "",         null: false
    t.datetime "maksuaika",                                                                                    null: false
    t.datetime "lahetepvm",                                                                                    null: false
    t.string   "lahetetyyppi",                     limit: 150,                            default: "",         null: false
    t.integer  "laskutyyppi",                      limit: 4,                              default: 0,          null: false
    t.string   "laskuttaja",                       limit: 50,                             default: "",         null: false
    t.datetime "laskutettu",                                                                                   null: false
    t.string   "hyvak1",                           limit: 50,                             default: "",         null: false
    t.datetime "h1time",                                                                                       null: false
    t.string   "hyvak2",                           limit: 50,                             default: "",         null: false
    t.datetime "h2time",                                                                                       null: false
    t.string   "hyvak3",                           limit: 50,                             default: "",         null: false
    t.datetime "h3time",                                                                                       null: false
    t.string   "hyvak4",                           limit: 50,                             default: "",         null: false
    t.datetime "h4time",                                                                                       null: false
    t.string   "hyvak5",                           limit: 50,                             default: "",         null: false
    t.string   "hyvaksyja_nyt",                    limit: 50,                             default: "",         null: false
    t.datetime "h5time",                                                                                       null: false
    t.string   "hyvaksynnanmuutos",                limit: 1,                              default: "",         null: false
    t.integer  "prioriteettinro",                  limit: 4,                              default: 9,          null: false
    t.string   "vakisin_kerays",                   limit: 1,                              default: "",         null: false
    t.string   "viite",                            limit: 25,                             default: "",         null: false
    t.integer  "laskunro",                         limit: 8,                              default: 0,          null: false
    t.string   "viesti",                           limit: 70,                             default: "",         null: false
    t.text     "sisviesti1",                       limit: 65535
    t.text     "sisviesti2",                       limit: 65535
    t.text     "sisviesti3",                       limit: 65535
    t.text     "comments",                         limit: 65535
    t.string   "ohjausmerkki",                     limit: 70,                             default: "",         null: false
    t.string   "tilausyhteyshenkilo",              limit: 50,                             default: "",         null: false
    t.string   "asiakkaan_tilausnumero",           limit: 50,                             default: "",         null: false
    t.string   "kohde",                            limit: 50,                             default: "",         null: false
    t.integer  "myyja",                            limit: 4,                              default: 0,          null: false
    t.integer  "allekirjoittaja",                  limit: 4,                              default: 0,          null: false
    t.integer  "maksuehto",                        limit: 4,                              default: 0,          null: false
    t.string   "toimitustapa",                     limit: 50,                             default: "",         null: false
    t.integer  "toimitustavan_lahto",              limit: 4,                              default: 0,          null: false
    t.integer  "toimitustavan_lahto_siirto",       limit: 4,                              default: 0,          null: false
    t.string   "rahtivapaa",                       limit: 1,                              default: "",         null: false
    t.string   "rahtisopimus",                     limit: 12,                             default: "",         null: false
    t.string   "ebid",                             limit: 35,                             default: "",         null: false
    t.string   "ytunnus",                          limit: 15,                             default: "",         null: false
    t.string   "verkkotunnus",                     limit: 76,                             default: "",         null: false
    t.string   "ovttunnus",                        limit: 25,                             default: "",         null: false
    t.string   "toim_ovttunnus",                   limit: 25,                             default: "",         null: false
    t.string   "chn",                              limit: 3,                              default: "",         null: false
    t.date     "mapvm",                                                                                        null: false
    t.datetime "popvm",                                                                                        null: false
    t.decimal  "vienti_kurssi",                                  precision: 15, scale: 9, default: 0.0,        null: false
    t.decimal  "maksu_kurssi",                                   precision: 15, scale: 9, default: 0.0,        null: false
    t.string   "maksu_tili",                       limit: 10,                             default: "",         null: false
    t.string   "alv_tili",                         limit: 6,                              default: "",         null: false
    t.string   "tila",                             limit: 1,                              default: "",         null: false
    t.string   "alatila",                          limit: 2,                              default: "",         null: false
    t.string   "huolitsija",                       limit: 30,                             default: "",         null: false
    t.string   "jakelu",                           limit: 30,                             default: "",         null: false
    t.string   "kuljetus",                         limit: 150,                            default: "",         null: false
    t.string   "maksuteksti",                      limit: 30,                             default: "",         null: false
    t.text     "valmistuksen_lisatiedot",          limit: 65535
    t.text     "mainosteksti",                     limit: 65535
    t.datetime "muutospvm",                                                                                    null: false
    t.string   "muuttaja",                         limit: 50,                             default: "",         null: false
    t.string   "vakuutus",                         limit: 30,                             default: "",         null: false
    t.string   "kassalipas",                       limit: 150,                            default: "",         null: false
    t.string   "ketjutus",                         limit: 1,                              default: "",         null: false
    t.string   "sisainen",                         limit: 1,                              default: "",         null: false
    t.string   "osatoimitus",                      limit: 1,                              default: "",         null: false
    t.string   "splittauskielto",                  limit: 1,                              default: "",         null: false
    t.string   "jtkielto",                         limit: 1,                              default: "",         null: false
    t.string   "tilaustyyppi",                     limit: 1,                              default: "",         null: false
    t.string   "eilahetetta",                      limit: 1,                              default: "",         null: false
    t.string   "tilausvahvistus",                  limit: 150,                            default: "",         null: false
    t.integer  "laskutusvkopv",                    limit: 4,                              default: 0,          null: false
    t.string   "toimitusehto",                     limit: 60,                             default: "",         null: false
    t.string   "vienti",                           limit: 1,                              default: "",         null: false
    t.string   "kolmikantakauppa",                 limit: 1,                              default: "",         null: false
    t.string   "viitetxt",                         limit: 30,                             default: "",         null: false
    t.string   "ostotilauksen_kasittely",          limit: 150,                            default: "",         null: false
    t.decimal  "erikoisale",                                     precision: 5,  scale: 2, default: 0.0,        null: false
    t.decimal  "erikoisale_saapuminen",                          precision: 5,  scale: 2, default: 0.0,        null: false
    t.integer  "kerayslista",                      limit: 4,                              default: 0,          null: false
    t.integer  "liitostunnus",                     limit: 4,                              default: 0,          null: false
    t.decimal  "viikorkopros",                                   precision: 5,  scale: 2, default: 0.0,        null: false
    t.decimal  "viikorkoeur",                                    precision: 8,  scale: 2, default: 0.0,        null: false
    t.integer  "varasto",                          limit: 8,                              default: 0,          null: false
    t.string   "tulostusalue",                     limit: 15,                             default: "",         null: false
    t.string   "kirjoitin",                        limit: 100,                            default: "",         null: false
    t.string   "noutaja",                          limit: 50,                             default: "",         null: false
    t.string   "kohdistettu",                      limit: 1,                              default: "",         null: false
    t.decimal  "rahti_huolinta",                                 precision: 16, scale: 6, default: 0.0,        null: false
    t.decimal  "rahti",                                          precision: 9,  scale: 2, default: 0.0,        null: false
    t.decimal  "rahti_etu",                                      precision: 16, scale: 6, default: 0.0,        null: false
    t.decimal  "rahti_etu_alv",                                  precision: 5,  scale: 2, default: 0.0,        null: false
    t.decimal  "osto_rahti_alv",                                 precision: 4,  scale: 2, default: 0.0,        null: false
    t.decimal  "osto_kulu_alv",                                  precision: 4,  scale: 2, default: 0.0,        null: false
    t.decimal  "osto_rivi_kulu_alv",                             precision: 4,  scale: 2, default: 0.0,        null: false
    t.decimal  "osto_rahti",                                     precision: 16, scale: 6, default: 0.0,        null: false
    t.decimal  "osto_kulu",                                      precision: 16, scale: 6, default: 0.0,        null: false
    t.decimal  "osto_rivi_kulu",                                 precision: 16, scale: 6, default: 0.0,        null: false
    t.string   "maa_lahetys",                      limit: 2,                              default: "",         null: false
    t.string   "maa_maara",                        limit: 2,                              default: "",         null: false
    t.string   "maa_alkupera",                     limit: 2,                              default: "",         null: false
    t.integer  "kuljetusmuoto",                    limit: 4,                              default: 0,          null: false
    t.integer  "kauppatapahtuman_luonne",          limit: 4,                              default: 0,          null: false
    t.decimal  "bruttopaino",                                    precision: 8,  scale: 2, default: 0.0,        null: false
    t.string   "sisamaan_kuljetus",                limit: 30,                             default: "",         null: false
    t.string   "sisamaan_kuljetus_kansallisuus",   limit: 2,                              default: "",         null: false
    t.string   "aktiivinen_kuljetus",              limit: 30,                             default: "",         null: false
    t.integer  "kontti",                           limit: 4,                              default: 0,          null: false
    t.string   "valmistuksen_tila",                limit: 2,                              default: "",         null: false
    t.string   "aktiivinen_kuljetus_kansallisuus", limit: 2,                              default: "",         null: false
    t.integer  "sisamaan_kuljetusmuoto",           limit: 4,                              default: 0,          null: false
    t.string   "poistumistoimipaikka",             limit: 80,                             default: "",         null: false
    t.string   "poistumistoimipaikka_koodi",       limit: 8,                              default: "",         null: false
    t.string   "aiotut_rajatoimipaikat",           limit: 255,                            default: "",         null: false
    t.string   "maaratoimipaikka",                 limit: 255,                            default: "",         null: false
    t.decimal  "lisattava_era",                                  precision: 8,  scale: 2, default: 0.0,        null: false
    t.decimal  "vahennettava_era",                               precision: 8,  scale: 2, default: 0.0,        null: false
    t.string   "tullausnumero",                    limit: 25,                             default: "",         null: false
    t.string   "vientipaperit_palautettu",         limit: 1,                              default: "",         null: false
    t.string   "piiri",                            limit: 150,                            default: "",         null: false
    t.datetime "lahetetty_ulkoiseen_varastoon"
    t.integer  "campaign_id",                      limit: 4
    t.integer  "siirtolistan_vastaanotto",         limit: 4,                              default: 0,          null: false
    t.integer  "varastosiirto_tunnus",             limit: 4,                              default: 0,          null: false
    t.integer  "pakkaamo",                         limit: 4,                              default: 0,          null: false
    t.integer  "jaksotettu",                       limit: 4,                              default: 0,          null: false
    t.integer  "factoringsiirtonumero",            limit: 4,                              default: 0,          null: false
    t.integer  "directdebitsiirtonumero",          limit: 4,                              default: 0,          null: false
    t.string   "ohjelma_moduli",                   limit: 50,                             default: "PUPESOFT", null: false
    t.integer  "label",                            limit: 4,                              default: 0,          null: false
    t.integer  "tunnusnippu",                      limit: 4,                              default: 0,          null: false
    t.integer  "vanhatunnus",                      limit: 4,                              default: 0,          null: false
  end

  add_index "lasku", ["nimi"], name: "asiakasnimi", type: :fulltext
  add_index "lasku", ["toim_nimi"], name: "asiakastoim_nimi", type: :fulltext
  add_index "lasku", ["yhtio", "alatila"], name: "alatila_index", using: :btree
  add_index "lasku", ["yhtio", "asiakkaan_tilausnumero"], name: "yhtio_asiakkaan_tilausnumero", using: :btree
  add_index "lasku", ["yhtio", "hyvaksyja_nyt"], name: "yhtio_hyvaksyjanyt", using: :btree
  add_index "lasku", ["yhtio", "jaksotettu"], name: "yhtio_jaksotettu", using: :btree
  add_index "lasku", ["yhtio", "laskunro"], name: "lasno_index", using: :btree
  add_index "lasku", ["yhtio", "liitostunnus"], name: "yhtio_liitostunnus", using: :btree
  add_index "lasku", ["yhtio", "tila", "alatila"], name: "tila_index", using: :btree
  add_index "lasku", ["yhtio", "tila", "erpcm"], name: "index_lasku_on_yhtio_and_tila_and_erpcm", using: :btree
  add_index "lasku", ["yhtio", "tila", "factoringsiirtonumero"], name: "factoring", using: :btree
  add_index "lasku", ["yhtio", "tila", "kerayslista"], name: "yhtio_tila_kerayslista", using: :btree
  add_index "lasku", ["yhtio", "tila", "laskunro"], name: "yhtio_tila_laskunro", using: :btree
  add_index "lasku", ["yhtio", "tila", "liitostunnus", "tapvm"], name: "yhtio_tila_liitostunnus_tapvm", using: :btree
  add_index "lasku", ["yhtio", "tila", "luontiaika"], name: "yhtio_tila_luontiaika", using: :btree
  add_index "lasku", ["yhtio", "tila", "mapvm"], name: "yhtio_tila_mapvm", using: :btree
  add_index "lasku", ["yhtio", "tila", "olmapvm"], name: "yhtio_tila_olmapvm", using: :btree
  add_index "lasku", ["yhtio", "tila", "summa"], name: "yhtio_tila_summa", using: :btree
  add_index "lasku", ["yhtio", "tila", "summa_valuutassa"], name: "yhtio_tila_summavaluutassa", using: :btree
  add_index "lasku", ["yhtio", "tila", "tapvm"], name: "yhtio_tila_tapvm", using: :btree
  add_index "lasku", ["yhtio", "tila", "vienti", "kohdistettu"], name: "kohdistus_index", using: :btree
  add_index "lasku", ["yhtio", "tila", "viite"], name: "tila_viite", using: :btree
  add_index "lasku", ["yhtio", "tila", "ytunnus", "tapvm"], name: "yhtio_tila_ytunnus_tapvm", using: :btree
  add_index "lasku", ["yhtio", "toimitustavan_lahto"], name: "yhtio_lahto", using: :btree
  add_index "lasku", ["yhtio", "tunnusnippu"], name: "yhtio_tunnusnippu", using: :btree
  add_index "lasku", ["yhtio", "vanhatunnus"], name: "yhtio_vanhatunnus", using: :btree
  add_index "lasku", ["yhtio", "ytunnus"], name: "yhtio_ytunnus", using: :btree

  create_table "laskun_lisatiedot", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",                                    limit: 5,                             default: "",  null: false
    t.integer  "otunnus",                                  limit: 4,                             default: 0,   null: false
    t.string   "luontitapa",                               limit: 30,                            default: "",  null: false
    t.integer  "rahlaskelma_rahoitettava_positio",         limit: 4,                             default: 0,   null: false
    t.decimal  "rahlaskelma_jaannosvelka_vaihtokohteesta",               precision: 8, scale: 2, default: 0.0, null: false
    t.decimal  "rahlaskelma_perustamiskustannus",                        precision: 8, scale: 2, default: 0.0, null: false
    t.decimal  "rahlaskelma_muutluottokustannukset",                     precision: 8, scale: 2, default: 0.0, null: false
    t.decimal  "rahlaskelma_sopajankorko",                               precision: 8, scale: 2, default: 0.0, null: false
    t.integer  "rahlaskelma_maksuerienlkm",                limit: 4,                             default: 0,   null: false
    t.integer  "rahlaskelma_luottoaikakk",                 limit: 4,                             default: 0,   null: false
    t.date     "rahlaskelma_ekaerpcm",                                                                         null: false
    t.decimal  "rahlaskelma_erankasittelymaksu",                         precision: 8, scale: 2, default: 0.0, null: false
    t.decimal  "rahlaskelma_tilinavausmaksu",                            precision: 8, scale: 2, default: 0.0, null: false
    t.string   "rahlaskelma_viitekorko",                   limit: 20,                            default: "",  null: false
    t.decimal  "rahlaskelma_marginaalikorko",                            precision: 8, scale: 2, default: 0.0, null: false
    t.string   "rahlaskelma_lyhennystapa",                 limit: 1,                             default: "",  null: false
    t.decimal  "rahlaskelma_poikkeava_era",                              precision: 8, scale: 2, default: 0.0, null: false
    t.integer  "rahlaskelma_nfref",                        limit: 4,                             default: 0,   null: false
    t.string   "vakuutushak_vakuutusyhtio",                limit: 50,                            default: "",  null: false
    t.date     "vakuutushak_alkamispaiva",                                                                     null: false
    t.string   "vakuutushak_kaskolaji",                    limit: 50,                            default: "",  null: false
    t.integer  "vakuutushak_maksuerat",                    limit: 4,                             default: 0,   null: false
    t.decimal  "vakuutushak_perusomavastuu",                             precision: 8, scale: 2, default: 0.0, null: false
    t.decimal  "vakuutushak_runko_takila_purjeet",                       precision: 8, scale: 2, default: 0.0, null: false
    t.decimal  "vakuutushak_moottori",                                   precision: 8, scale: 2, default: 0.0, null: false
    t.decimal  "vakuutushak_varusteet",                                  precision: 8, scale: 2, default: 0.0, null: false
    t.decimal  "vakuutushak_yhteensa",                                   precision: 8, scale: 2, default: 0.0, null: false
    t.string   "rekisteilmo_rekisterinumero",              limit: 20,                            default: "",  null: false
    t.string   "rekisteilmo_paakayttokunta",               limit: 50,                            default: "",  null: false
    t.string   "rekisteilmo_kieli",                        limit: 50,                            default: "",  null: false
    t.string   "rekisteilmo_tyyppi",                       limit: 50,                            default: "",  null: false
    t.integer  "rekisteilmo_omistajienlkm",                limit: 4,                             default: 0,   null: false
    t.string   "rekisteilmo_omistajankotikunta",           limit: 50,                            default: "",  null: false
    t.string   "rekisteilmo_lisatietoja",                  limit: 150,                           default: "",  null: false
    t.string   "rekisteilmo_laminointi",                   limit: 1,                             default: "",  null: false
    t.string   "rekisteilmo_suoramarkkinointi",            limit: 1,                             default: "",  null: false
    t.string   "rekisteilmo_veneen_nimi",                  limit: 150,                           default: "",  null: false
    t.string   "rekisteilmo_omistaja",                     limit: 55,                            default: "",  null: false
    t.string   "kolm_ovttunnus",                           limit: 25,                            default: "",  null: false
    t.string   "kolm_nimi",                                limit: 60,                            default: "",  null: false
    t.string   "kolm_nimitark",                            limit: 60,                            default: "",  null: false
    t.string   "kolm_osoite",                              limit: 55,                            default: "",  null: false
    t.string   "kolm_postino",                             limit: 15,                            default: "",  null: false
    t.string   "kolm_postitp",                             limit: 35,                            default: "",  null: false
    t.string   "kolm_maa",                                 limit: 35,                            default: "",  null: false
    t.string   "laskutus_nimi",                            limit: 60,                            default: "",  null: false
    t.string   "laskutus_nimitark",                        limit: 60,                            default: "",  null: false
    t.string   "laskutus_osoite",                          limit: 60,                            default: "",  null: false
    t.string   "laskutus_postino",                         limit: 60,                            default: "",  null: false
    t.string   "laskutus_postitp",                         limit: 60,                            default: "",  null: false
    t.string   "laskutus_maa",                             limit: 60,                            default: "",  null: false
    t.string   "toimitusehto2",                            limit: 60,                            default: "",  null: false
    t.string   "kasinsyotetty_viite",                      limit: 25,                            default: "",  null: false
    t.integer  "asiakkaan_kohde",                          limit: 4,                             default: 0,   null: false
    t.string   "kantaasiakastunnus",                       limit: 255,                           default: "",  null: false
    t.string   "ulkoinen_tarkenne",                        limit: 30,                            default: "",  null: false
    t.string   "noutopisteen_tunnus",                      limit: 12,                            default: "",  null: false
    t.text     "saate",                                    limit: 65535
    t.integer  "yhteyshenkilo_kaupallinen",                limit: 4,                             default: 0,   null: false
    t.integer  "yhteyshenkilo_tekninen",                   limit: 4,                             default: 0,   null: false
    t.string   "rahlaskelma_hetu_tarkistus",               limit: 1,                             default: "",  null: false
    t.string   "rahlaskelma_hetu_tarkastaja",              limit: 150,                           default: "",  null: false
    t.string   "rahlaskelma_hetu_asiakirjamyontaja",       limit: 150,                           default: "",  null: false
    t.string   "rahlaskelma_hetu_asiakirjanro",            limit: 150,                           default: "",  null: false
    t.string   "rahlaskelma_hetu_kolm_tarkistus",          limit: 1,                             default: "",  null: false
    t.string   "rahlaskelma_hetu_kolm_tarkastaja",         limit: 150,                           default: "",  null: false
    t.string   "rahlaskelma_hetu_kolm_asiakirjanro",       limit: 150,                           default: "",  null: false
    t.string   "rahlaskelma_hetu_kolm_asiakirjamyontaja",  limit: 150,                           default: "",  null: false
    t.string   "rahlaskelma_takuukirja",                   limit: 1,                             default: "",  null: false
    t.string   "rahlaskelma_huoltokirja",                  limit: 1,                             default: "",  null: false
    t.string   "rahlaskelma_kayttoohjeet",                 limit: 1,                             default: "",  null: false
    t.string   "rahlaskelma_opastus",                      limit: 1,                             default: "",  null: false
    t.string   "rahlaskelma_kuntotestitodistus",           limit: 1,                             default: "",  null: false
    t.string   "rahlaskelma_kayttotarkoitus",              limit: 1,                             default: "",  null: false
    t.string   "sopimus_kk",                               limit: 90,                            default: "",  null: false
    t.string   "sopimus_pp",                               limit: 90,                            default: "",  null: false
    t.date     "sopimus_alkupvm",                                                                              null: false
    t.date     "sopimus_loppupvm",                                                                             null: false
    t.text     "sopimus_lisatietoja",                      limit: 65535
    t.text     "sopimus_lisatietoja2",                     limit: 65535
    t.string   "sopimus_numero",                           limit: 50,                            default: ""
    t.string   "projektipaallikko",                        limit: 50,                            default: "",  null: false
    t.string   "seuranta",                                 limit: 5,                             default: "",  null: false
    t.integer  "tunnusnippu_tarjous",                      limit: 4,                             default: 0,   null: false
    t.integer  "projekti",                                 limit: 4,                             default: 0,   null: false
    t.string   "rivihintoja_ei_nayteta",                   limit: 1,                             default: "",  null: false
    t.string   "yllapito_kuukausihinnoittelu",             limit: 1
    t.string   "laatija",                                  limit: 50,                            default: "",  null: false
    t.datetime "luontiaika",                                                                                   null: false
    t.datetime "muutospvm",                                                                                    null: false
    t.string   "muuttaja",                                 limit: 50,                            default: "",  null: false
  end

  add_index "laskun_lisatiedot", ["yhtio", "otunnus"], name: "yhtio_otunnus", unique: true, using: :btree

  create_table "liitetiedostot", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",           limit: 5,          default: "", null: false
    t.string   "liitos",          limit: 50,         default: "", null: false
    t.integer  "liitostunnus",    limit: 4,          default: 0,  null: false
    t.binary   "data",            limit: 4294967295
    t.text     "selite",          limit: 65535
    t.string   "kieli",           limit: 2,          default: "", null: false
    t.string   "filename",        limit: 50,         default: "", null: false
    t.string   "filesize",        limit: 50,         default: "", null: false
    t.string   "filetype",        limit: 50,         default: "", null: false
    t.integer  "image_width",     limit: 4,          default: 0,  null: false
    t.integer  "image_height",    limit: 4,          default: 0,  null: false
    t.integer  "image_bits",      limit: 4,          default: 0,  null: false
    t.integer  "image_channels",  limit: 4,          default: 0,  null: false
    t.string   "kayttotarkoitus", limit: 150,        default: "", null: false
    t.integer  "jarjestys",       limit: 4,          default: 0,  null: false
    t.string   "laatija",         limit: 50,         default: "", null: false
    t.datetime "luontiaika",                                      null: false
    t.datetime "muutospvm",                                       null: false
    t.string   "muuttaja",        limit: 50,         default: "", null: false
  end

  add_index "liitetiedostot", ["yhtio", "liitos", "liitostunnus"], name: "yhtio_liitos_liitostunnus", using: :btree

  create_table "maat", primary_key: "tunnus", force: :cascade do |t|
    t.string "koodi",        limit: 2,   default: "", null: false
    t.string "iso3",         limit: 3,   default: "", null: false
    t.string "nimi",         limit: 80,  default: "", null: false
    t.string "name",         limit: 150, default: "", null: false
    t.string "eu",           limit: 2,   default: "", null: false
    t.string "ryhma_tunnus", limit: 4,   default: "", null: false
  end

  add_index "maat", ["koodi", "nimi"], name: "koodi_nimi", using: :btree
  add_index "maat", ["koodi", "ryhma_tunnus"], name: "koodi_ryhma", unique: true, using: :btree

  create_table "mail_servers", force: :cascade do |t|
    t.string   "imap_server",     limit: 255
    t.string   "imap_username",   limit: 255
    t.string   "imap_password",   limit: 255
    t.string   "smtp_server",     limit: 255
    t.string   "smtp_username",   limit: 255
    t.string   "smtp_password",   limit: 255
    t.string   "process_dir",     limit: 255
    t.string   "done_dir",        limit: 255
    t.string   "processing_type", limit: 255
    t.integer  "company_id",      limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "mail_servers", ["company_id"], name: "index_mail_servers_on_company_id", using: :btree

  create_table "maksu", primary_key: "tunnus", force: :cascade do |t|
    t.string  "yhtio",    limit: 5,                           default: "",  null: false
    t.string  "konserni", limit: 5,                           default: "",  null: false
    t.string  "kuka",     limit: 50,                          default: "",  null: false
    t.date    "tapvm",                                                      null: false
    t.string  "tyyppi",   limit: 2,                           default: "",  null: false
    t.decimal "summa",               precision: 12, scale: 2, default: 0.0, null: false
    t.string  "selite",   limit: 50,                          default: "",  null: false
    t.string  "maksettu", limit: 1,                           default: "",  null: false
  end

  create_table "maksuehto", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",              limit: 5,                          default: "",  null: false
    t.string   "teksti",             limit: 40,                         default: "",  null: false
    t.integer  "rel_pvm",            limit: 4,                          default: 0,   null: false
    t.date     "abs_pvm"
    t.integer  "kassa_relpvm",       limit: 4,                          default: 0,   null: false
    t.date     "kassa_abspvm"
    t.decimal  "kassa_alepros",                 precision: 5, scale: 2, default: 0.0, null: false
    t.string   "jv",                 limit: 1,                          default: "",  null: false
    t.string   "kateinen",           limit: 1,                          default: "",  null: false
    t.integer  "factoring_id",       limit: 4
    t.integer  "directdebit_id",     limit: 4
    t.integer  "pankkiyhteystiedot", limit: 4,                          default: 0,   null: false
    t.string   "itsetulostus",       limit: 1,                          default: "",  null: false
    t.string   "jaksotettu",         limit: 1,                          default: "",  null: false
    t.string   "erapvmkasin",        limit: 1,                          default: "",  null: false
    t.string   "sallitut_maat",      limit: 50,                         default: "",  null: false
    t.string   "kaytossa",           limit: 1,                          default: "",  null: false
    t.integer  "jarjestys",          limit: 4,                          default: 0,   null: false
    t.string   "laatija",            limit: 50,                         default: "",  null: false
    t.datetime "luontiaika",                                                          null: false
    t.datetime "muutospvm",                                                           null: false
    t.string   "muuttaja",           limit: 50,                         default: "",  null: false
  end

  create_table "maksupaatetapahtumat", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",            limit: 5,                              default: "",  null: false
    t.string   "maksutapa",        limit: 50,                             default: "",  null: false
    t.decimal  "summa_valuutassa",               precision: 12, scale: 2, default: 0.0, null: false
    t.string   "valkoodi",         limit: 3,                              default: "",  null: false
    t.string   "tila",             limit: 1,                              default: "",  null: false
    t.text     "asiakkaan_kuitti", limit: 65535
    t.text     "kauppiaan_kuitti", limit: 65535
    t.string   "tilausnumero",     limit: 50,                             default: "",  null: false
    t.string   "laatija",          limit: 50,                             default: "",  null: false
    t.datetime "luontiaika",                                                            null: false
    t.datetime "muutospvm",                                                             null: false
    t.string   "muuttaja",         limit: 50,                             default: "",  null: false
  end

  add_index "maksupaatetapahtumat", ["yhtio"], name: "yhtio_index", using: :btree

  create_table "maksupositio", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",       limit: 6,                              default: "",  null: false
    t.integer  "otunnus",     limit: 4,                              default: 0,   null: false
    t.integer  "positio",     limit: 4,                              default: 0,   null: false
    t.integer  "maksuehto",   limit: 4,                              default: 0,   null: false
    t.string   "lisatiedot",  limit: 150,                            default: "",  null: false
    t.decimal  "osuus",                     precision: 7,  scale: 4, default: 0.0, null: false
    t.decimal  "summa",                     precision: 12, scale: 2, default: 0.0, null: false
    t.string   "kuvaus",      limit: 150,                            default: "",  null: false
    t.text     "ohje",        limit: 65535
    t.date     "erpcm",                                                            null: false
    t.datetime "luotu",                                                            null: false
    t.string   "luonut",      limit: 50,                             default: "",  null: false
    t.integer  "laskunro",    limit: 4,                              default: 0,   null: false
    t.integer  "uusiotunnus", limit: 4,                              default: 0,   null: false
  end

  create_table "messenger", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",         limit: 5,     default: "", null: false
    t.string   "kuka",          limit: 50,    default: "", null: false
    t.string   "vastaanottaja", limit: 50,    default: "", null: false
    t.string   "ryhma",         limit: 50,    default: "", null: false
    t.text     "viesti",        limit: 65535
    t.string   "status",        limit: 1,     default: "", null: false
    t.datetime "luontiaika",                               null: false
  end

  add_index "messenger", ["yhtio", "kuka", "status"], name: "yhtio_kuka_status", using: :btree
  add_index "messenger", ["yhtio", "vastaanottaja", "status"], name: "yhtio_vastaanottaja_status", using: :btree

  create_table "muisti", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",      limit: 5,     default: "", null: false
    t.string   "kuka",       limit: 50,    default: "", null: false
    t.string   "haku",       limit: 20,    default: "", null: false
    t.string   "nimi",       limit: 50,    default: "", null: false
    t.text     "kuvaus",     limit: 65535
    t.string   "var",        limit: 50,    default: "", null: false
    t.text     "value",      limit: 65535
    t.string   "array",      limit: 1,     default: "", null: false
    t.datetime "luontiaika",                            null: false
    t.string   "laatija",    limit: 50,    default: "", null: false
    t.datetime "muokattu",                              null: false
    t.string   "muokannut",  limit: 50,    default: "", null: false
  end

  add_index "muisti", ["yhtio", "kuka", "haku", "nimi", "var"], name: "haut", unique: true, using: :btree

  create_table "oikeu", primary_key: "tunnus", force: :cascade do |t|
    t.string   "kuka",          limit: 50,  default: "", null: false
    t.integer  "user_id",       limit: 4
    t.string   "sovellus",      limit: 50,  default: "", null: false
    t.string   "nimi",          limit: 100, default: "", null: false
    t.string   "alanimi",       limit: 100, default: "", null: false
    t.string   "paivitys",      limit: 1,   default: "", null: false
    t.string   "lukittu",       limit: 1,   default: "", null: false
    t.string   "nimitys",       limit: 60,  default: "", null: false
    t.integer  "jarjestys",     limit: 4,   default: 0,  null: false
    t.integer  "jarjestys2",    limit: 4,   default: 0,  null: false
    t.string   "profiili",      limit: 100, default: "", null: false
    t.string   "yhtio",         limit: 5,   default: "", null: false
    t.string   "hidden",        limit: 1,   default: "", null: false
    t.string   "usermanualurl", limit: 255, default: "", null: false
    t.string   "laatija",       limit: 50,  default: "", null: false
    t.datetime "luontiaika",                             null: false
    t.datetime "muutospvm",                              null: false
    t.string   "muuttaja",      limit: 50,  default: "", null: false
  end

  add_index "oikeu", ["user_id"], name: "user_id", using: :btree
  add_index "oikeu", ["yhtio", "kuka", "sovellus", "nimi", "alanimi"], name: "oikeudet_index", unique: true, using: :btree
  add_index "oikeu", ["yhtio", "kuka", "sovellus"], name: "sovellus_index", using: :btree
  add_index "oikeu", ["yhtio", "sovellus", "nimi", "alanimi"], name: "menut_index", using: :btree

  create_table "ostorivien_vahvistus", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",              limit: 5,  default: "",  null: false
    t.integer  "tilausrivin_tunnus", limit: 4,  default: 0,   null: false
    t.string   "vahvistettu",        limit: 1,  default: "0", null: false
    t.datetime "vahvistettuaika",                             null: false
    t.string   "laatija",            limit: 50, default: "",  null: false
    t.datetime "luontiaika",                                  null: false
  end

  add_index "ostorivien_vahvistus", ["yhtio", "tilausrivin_tunnus"], name: "yhtio_rivitunnus", using: :btree

  create_table "pakkaamo", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",          limit: 5,   default: "", null: false
    t.string   "nimi",           limit: 150, default: "", null: false
    t.string   "lokero",         limit: 5,   default: "", null: false
    t.integer  "prio",           limit: 4,   default: 0,  null: false
    t.integer  "pakkaamon_prio", limit: 4,   default: 0,  null: false
    t.integer  "varasto",        limit: 4,   default: 0,  null: false
    t.string   "printteri0",     limit: 20,  default: "", null: false
    t.string   "printteri1",     limit: 20,  default: "", null: false
    t.string   "printteri2",     limit: 20,  default: "", null: false
    t.string   "printteri3",     limit: 20,  default: "", null: false
    t.string   "printteri4",     limit: 20,  default: "", null: false
    t.string   "printteri6",     limit: 20,  default: "", null: false
    t.string   "printteri7",     limit: 20,  default: "", null: false
    t.string   "laatija",        limit: 50,  default: "", null: false
    t.datetime "luontiaika",                              null: false
    t.datetime "muutospvm",                               null: false
    t.string   "muuttaja",       limit: 50,  default: "", null: false
  end

  create_table "pakkaus", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",                       limit: 5,                           default: "",  null: false
    t.string   "pakkaus",                     limit: 50,                          default: "",  null: false
    t.string   "pakkauskuvaus",               limit: 50,                          default: "",  null: false
    t.string   "pakkausveloitus_tuotenumero", limit: 60,                          default: "",  null: false
    t.string   "erikoispakkaus",              limit: 1,                           default: "",  null: false
    t.decimal  "korkeus",                                precision: 10, scale: 4, default: 0.0, null: false
    t.decimal  "leveys",                                 precision: 10, scale: 4, default: 0.0, null: false
    t.decimal  "syvyys",                                 precision: 10, scale: 4, default: 0.0, null: false
    t.decimal  "paino",                                  precision: 12, scale: 4, default: 0.0, null: false
    t.decimal  "oma_paino",                              precision: 12, scale: 4, default: 0.0, null: false
    t.decimal  "minimi_tilavuus",                        precision: 10, scale: 4, default: 0.0, null: false
    t.decimal  "minimi_paino",                           precision: 12, scale: 4, default: 0.0, null: false
    t.integer  "kayttoprosentti",             limit: 1,                           default: 100, null: false
    t.string   "yksin_eraan",                 limit: 1,                           default: "",  null: false
    t.decimal  "puukotuskerroin",                        precision: 4,  scale: 3, default: 0.0, null: false
    t.string   "rahtivapaa_veloitus",         limit: 1,                           default: "",  null: false
    t.integer  "jarjestys",                   limit: 4,                           default: 0,   null: false
    t.string   "laatija",                     limit: 50,                          default: "",  null: false
    t.datetime "luontiaika",                                                                    null: false
    t.datetime "muutospvm",                                                                     null: false
    t.string   "muuttaja",                    limit: 50,                          default: "",  null: false
  end

  add_index "pakkaus", ["yhtio", "pakkaus", "pakkauskuvaus"], name: "yhtio_pakkaus_pakkauskuvaus", using: :btree

  create_table "pakkauskoodit", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",            limit: 5,  default: "", null: false
    t.integer  "pakkaus",          limit: 4,  default: 0,  null: false
    t.string   "rahdinkuljettaja", limit: 40, default: "", null: false
    t.string   "koodi",            limit: 50, default: "", null: false
    t.string   "laatija",          limit: 50, default: "", null: false
    t.datetime "luontiaika",                               null: false
    t.datetime "muutospvm",                                null: false
    t.string   "muuttaja",         limit: 50, default: "", null: false
  end

  create_table "pankkiyhteys", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",                                limit: 5
    t.string   "pankki",                               limit: 60
    t.string   "customer_id",                          limit: 60
    t.boolean  "hae_saldo",                                          default: false, null: false
    t.boolean  "hae_factoring",                                      default: false, null: false
    t.boolean  "hae_laskut",                                         default: false, null: false
    t.text     "signing_certificate",                  limit: 65535
    t.datetime "signing_certificate_valid_to"
    t.text     "signing_private_key",                  limit: 65535
    t.text     "encryption_certificate",               limit: 65535
    t.datetime "encryption_certificate_valid_to"
    t.text     "encryption_private_key",               limit: 65535
    t.text     "bank_encryption_certificate",          limit: 65535
    t.datetime "bank_encryption_certificate_valid_to"
    t.text     "bank_root_certificate",                limit: 65535
    t.datetime "bank_root_certificate_valid_to"
    t.text     "ca_certificate",                       limit: 65535
    t.datetime "ca_certificate_valid_to"
  end

  create_table "pankkiyhteystiedot", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",        limit: 5,  default: "", null: false
    t.string   "nimitys",      limit: 80, default: "", null: false
    t.string   "pankkinimi1",  limit: 80, default: "", null: false
    t.string   "pankkitili1",  limit: 80, default: "", null: false
    t.string   "pankkiiban1",  limit: 60, default: "", null: false
    t.string   "pankkiswift1", limit: 60, default: "", null: false
    t.string   "pankkinimi2",  limit: 80, default: "", null: false
    t.string   "pankkitili2",  limit: 80, default: "", null: false
    t.string   "pankkiiban2",  limit: 60, default: "", null: false
    t.string   "pankkiswift2", limit: 60, default: "", null: false
    t.string   "pankkinimi3",  limit: 80, default: "", null: false
    t.string   "pankkitili3",  limit: 80, default: "", null: false
    t.string   "pankkiiban3",  limit: 60, default: "", null: false
    t.string   "pankkiswift3", limit: 60, default: "", null: false
    t.string   "viite",        limit: 2,  default: "", null: false
    t.string   "laatija",      limit: 50, default: "", null: false
    t.datetime "luontiaika",                           null: false
    t.datetime "muutospvm",                            null: false
    t.string   "muuttaja",     limit: 50, default: "", null: false
  end

  create_table "panttitili", primary_key: "tunnus", force: :cascade do |t|
    t.string  "yhtio",             limit: 5,                           default: "",  null: false
    t.integer "asiakas",           limit: 4,                           default: 0,   null: false
    t.string  "tuoteno",           limit: 60,                          default: "",  null: false
    t.string  "status",            limit: 1,                           default: "",  null: false
    t.decimal "kpl",                          precision: 12, scale: 2, default: 0.0, null: false
    t.decimal "hinta",                        precision: 16, scale: 6, default: 0.0, null: false
    t.decimal "alv",                          precision: 5,  scale: 2, default: 0.0, null: false
    t.decimal "erikoisale",                   precision: 5,  scale: 2, default: 0.0, null: false
    t.decimal "ale1",                         precision: 5,  scale: 2, default: 0.0, null: false
    t.decimal "ale2",                         precision: 5,  scale: 2, default: 0.0, null: false
    t.decimal "ale3",                         precision: 5,  scale: 2, default: 0.0, null: false
    t.date    "myyntipvm",                                                           null: false
    t.integer "myyntitilausnro",   limit: 4,                           default: 0,   null: false
    t.date    "kaytettypvm",                                                         null: false
    t.integer "kaytettytilausnro", limit: 4,                           default: 0,   null: false
  end

  add_index "panttitili", ["yhtio", "status", "myyntipvm"], name: "yhtio_status_myyntipvm", using: :btree
  add_index "panttitili", ["yhtio", "tuoteno", "asiakas", "status"], name: "yhtio_tuoteno_asiakas_status", using: :btree
  add_index "panttitili", ["yhtio", "tuoteno"], name: "yhtio_tuoteno", using: :btree

  create_table "pending_updates", force: :cascade do |t|
    t.integer "pending_updatable_id",   limit: 4
    t.string  "pending_updatable_type", limit: 255
    t.string  "key",                    limit: 255
    t.text    "value",                  limit: 65535
  end

  add_index "pending_updates", ["pending_updatable_id"], name: "index_pending_updates_on_pending_updatable_id", using: :btree

  create_table "perusalennus", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",      limit: 5,                          default: "",  null: false
    t.string   "ryhma",      limit: 15,                         default: "",  null: false
    t.string   "selite",     limit: 50,                         default: "",  null: false
    t.decimal  "alennus",               precision: 5, scale: 2, default: 0.0, null: false
    t.string   "laatija",    limit: 50,                         default: "",  null: false
    t.datetime "luontiaika",                                                  null: false
    t.datetime "muutospvm",                                                   null: false
    t.string   "muuttaja",   limit: 50,                         default: "",  null: false
  end

  add_index "perusalennus", ["yhtio", "ryhma"], name: "yhtio_ryhma", unique: true, using: :btree

  create_table "puun_alkio", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",       limit: 5,   default: "", null: false
    t.string   "liitos",      limit: 60,  default: "", null: false
    t.string   "kieli",       limit: 2,   default: "", null: false
    t.string   "laji",        limit: 150, default: "", null: false
    t.string   "kutsuja",     limit: 150, default: "", null: false
    t.integer  "puun_tunnus", limit: 4,   default: 0,  null: false
    t.integer  "jarjestys",   limit: 4,   default: 0,  null: false
    t.string   "laatija",     limit: 50,  default: "", null: false
    t.datetime "luontiaika",                           null: false
    t.datetime "muutospvm",                            null: false
    t.string   "muuttaja",    limit: 50,  default: "", null: false
  end

  add_index "puun_alkio", ["yhtio", "laji", "liitos"], name: "yhtio_laji_liitos", using: :btree
  add_index "puun_alkio", ["yhtio", "laji", "puun_tunnus"], name: "yhtio_laji_puun_tunnus", using: :btree
  add_index "puun_alkio", ["yhtio", "liitos", "laji", "puun_tunnus", "kieli"], name: "yhtio_laji_liitos_puuntunnus_kieli", unique: true, using: :btree

  create_table "rahdinkuljettajat", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",                         limit: 5,                          default: "",  null: false
    t.string   "koodi",                         limit: 50,                         default: "",  null: false
    t.string   "nimi",                          limit: 50,                         default: "",  null: false
    t.string   "neutraali",                     limit: 1,                          default: "",  null: false
    t.decimal  "pakkauksen_sarman_minimimitta",            precision: 5, scale: 2, default: 0.0, null: false
    t.string   "laatija",                       limit: 50,                         default: "",  null: false
    t.datetime "luontiaika",                                                                     null: false
    t.datetime "muutospvm",                                                                      null: false
    t.string   "muuttaja",                      limit: 50,                         default: "",  null: false
  end

  create_table "rahtikirjanumero", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",         limit: 5,   default: "", null: false
    t.string   "rahtikirjanro", limit: 150, default: "", null: false
    t.string   "kayttaja",      limit: 50,  default: "", null: false
    t.datetime "kaytettyaika",                           null: false
    t.string   "laatija",       limit: 50,  default: "", null: false
    t.datetime "luontiaika",                             null: false
    t.datetime "muutospvm",                              null: false
    t.string   "muuttaja",      limit: 50,  default: "", null: false
  end

  create_table "rahtikirjat", primary_key: "tunnus", force: :cascade do |t|
    t.decimal  "kilot",                                         precision: 12, scale: 4, default: 0.0, null: false
    t.decimal  "kollit",                                        precision: 12, scale: 4, default: 0.0, null: false
    t.decimal  "kuutiot",                                       precision: 7,  scale: 4, default: 0.0, null: false
    t.decimal  "lavametri",                                     precision: 5,  scale: 2, default: 0.0, null: false
    t.string   "merahti",                         limit: 1,                              default: "",  null: false
    t.string   "pakkaus",                         limit: 50,                             default: "",  null: false
    t.string   "pakkauskuvaus",                   limit: 50,                             default: "",  null: false
    t.string   "pakkauskuvaustark",               limit: 50,                             default: "",  null: false
    t.integer  "poikkeava",                       limit: 4,                              default: 0,   null: false
    t.string   "rahtisopimus",                    limit: 12,                             default: "",  null: false
    t.integer  "otsikkonro",                      limit: 4,                              default: 0,   null: false
    t.text     "pakkaustieto_tunnukset",          limit: 65535
    t.string   "toimitustapa",                    limit: 50,                             default: "",  null: false
    t.string   "viitelah",                        limit: 30,                             default: "",  null: false
    t.string   "viitevas",                        limit: 30,                             default: "",  null: false
    t.text     "viesti",                          limit: 65535
    t.integer  "tulostuspaikka",                  limit: 8,                              default: 0,   null: false
    t.string   "tulostustapa",                    limit: 1,                              default: "",  null: false
    t.datetime "tulostettu",                                                                           null: false
    t.text     "rahtikirjanro",                   limit: 65535
    t.string   "sscc_ulkoinen",                   limit: 150,                            default: "",  null: false
    t.text     "tyhjanrahtikirjan_otsikkotiedot", limit: 65535
    t.string   "yhtio",                           limit: 5,                              default: "",  null: false
  end

  add_index "rahtikirjat", ["yhtio", "otsikkonro"], name: "otsikko_index", using: :btree
  add_index "rahtikirjat", ["yhtio", "rahtikirjanro"], name: "rahtikirjanro", length: {"yhtio"=>nil, "rahtikirjanro"=>150}, using: :btree

  create_table "rahtimaksut", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",        limit: 5,                           default: "",  null: false
    t.string   "toimitustapa", limit: 50,                          default: "",  null: false
    t.decimal  "kilotalku",               precision: 12, scale: 2, default: 0.0, null: false
    t.decimal  "kilotloppu",              precision: 12, scale: 2, default: 0.0, null: false
    t.integer  "kmalku",       limit: 4,                           default: 0,   null: false
    t.integer  "kmloppu",      limit: 4,                           default: 0,   null: false
    t.decimal  "rahtihinta",              precision: 12, scale: 2, default: 0.0, null: false
    t.string   "laatija",      limit: 50,                          default: "",  null: false
    t.datetime "luontiaika",                                                     null: false
    t.datetime "muutospvm",                                                      null: false
    t.string   "muuttaja",     limit: 50,                          default: "",  null: false
  end

  create_table "rahtisopimukset", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",        limit: 5,  default: "", null: false
    t.string   "toimitustapa", limit: 50, default: "", null: false
    t.integer  "asiakas",      limit: 4,  default: 0,  null: false
    t.string   "ytunnus",      limit: 15, default: "", null: false
    t.string   "rahtisopimus", limit: 12, default: "", null: false
    t.string   "selite",       limit: 50, default: "", null: false
    t.string   "muumaksaja",   limit: 50, default: "", null: false
    t.string   "laatija",      limit: 50, default: "", null: false
    t.datetime "luontiaika",                           null: false
    t.datetime "muutospvm",                            null: false
    t.string   "muuttaja",     limit: 50, default: "", null: false
  end

  create_table "sahkoisen_lahetteen_rivit", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",              limit: 5,                           default: "",  null: false
    t.integer  "otunnus",            limit: 4,                           default: 0,   null: false
    t.integer  "tilausrivin_tunnus", limit: 4,                           default: 0,   null: false
    t.string   "tuoteno",            limit: 60,                          default: "",  null: false
    t.decimal  "kpl",                           precision: 12, scale: 2, default: 0.0, null: false
    t.decimal  "myyntihinta",                   precision: 16, scale: 6, default: 0.0, null: false
    t.decimal  "ale",                           precision: 5,  scale: 2, default: 0.0, null: false
    t.string   "rekisterinumero",    limit: 7,                           default: "",  null: false
    t.string   "status",             limit: 1,                           default: "",  null: false
    t.string   "laatija",            limit: 50,                          default: "",  null: false
    t.datetime "luontiaika",                                                           null: false
    t.datetime "muutospvm",                                                            null: false
    t.string   "muuttaja",           limit: 50,                          default: "",  null: false
  end

  add_index "sahkoisen_lahetteen_rivit", ["yhtio", "otunnus", "tilausrivin_tunnus"], name: "yhtio_otunnus_tilausrivin_tunnus", using: :btree

  create_table "saldovahvistukset", primary_key: "tunnus", force: :cascade do |t|
    t.date    "lahetys_pvm"
    t.string  "saldovahvistus_viesti", limit: 150, default: "", null: false
    t.date    "avoin_saldo_pvm"
    t.string  "ryhmittely_tyyppi",     limit: 100, default: ""
    t.integer "liitostunnus",          limit: 4,   default: 0,  null: false
    t.string  "yhtio",                 limit: 5,   default: "", null: false
  end

  create_table "saldovahvistusrivit", primary_key: "tunnus", force: :cascade do |t|
    t.integer "saldovahvistus_tunnus", limit: 4,                          default: 0,   null: false
    t.string  "tyyppi",                limit: 1,                          default: "",  null: false
    t.integer "lasku_tunnus",          limit: 4,                          default: 0,   null: false
    t.integer "laskunro",              limit: 4,                          default: 0,   null: false
    t.date    "tapahtuma_pvm"
    t.date    "era_pvm"
    t.decimal "summa",                           precision: 12, scale: 2, default: 0.0, null: false
    t.string  "yhtio",                 limit: 5,                          default: "",  null: false
  end

  create_table "sanakirja", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",      limit: 5,     default: "", null: false
    t.text     "fi",         limit: 65535
    t.text     "se",         limit: 65535
    t.text     "no",         limit: 65535
    t.text     "en",         limit: 65535
    t.text     "de",         limit: 65535
    t.text     "dk",         limit: 65535
    t.text     "ru",         limit: 65535
    t.text     "ee",         limit: 65535
    t.datetime "aikaleima",                             null: false
    t.integer  "kysytty",    limit: 8,     default: 0,  null: false
    t.string   "laatija",    limit: 50,    default: "", null: false
    t.datetime "luontiaika",                            null: false
    t.datetime "muutospvm",                             null: false
    t.string   "muuttaja",   limit: 50,    default: "", null: false
    t.string   "synkronoi",  limit: 1,     default: "", null: false
  end

  add_index "sanakirja", ["fi"], name: "fi", length: {"fi"=>50}, using: :btree

  create_table "sarjanumeroseuranta", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",             limit: 5,                             default: "",  null: false
    t.string   "tuoteno",           limit: 60,                            default: "",  null: false
    t.string   "sarjanumero",       limit: 150,                           default: "",  null: false
    t.text     "lisatieto",         limit: 65535
    t.integer  "ostorivitunnus",    limit: 4,                             default: 0,   null: false
    t.integer  "myyntirivitunnus",  limit: 4,                             default: 0,   null: false
    t.integer  "siirtorivitunnus",  limit: 4,                             default: 0,   null: false
    t.string   "hyllyalue",         limit: 5,                             default: "",  null: false
    t.string   "hyllynro",          limit: 5,                             default: "",  null: false
    t.string   "hyllyvali",         limit: 5,                             default: "",  null: false
    t.string   "hyllytaso",         limit: 5,                             default: "",  null: false
    t.integer  "varasto",           limit: 4
    t.date     "takuu_alku",                                                            null: false
    t.date     "takuu_loppu",                                                           null: false
    t.date     "parasta_ennen",                                                         null: false
    t.integer  "perheid",           limit: 4,                             default: 0,   null: false
    t.string   "kaytetty",          limit: 1,                             default: "",  null: false
    t.decimal  "era_kpl",                         precision: 8, scale: 2, default: 0.0, null: false
    t.string   "laatija",           limit: 50,                            default: "",  null: false
    t.datetime "luontiaika",                                                            null: false
    t.datetime "muutospvm",                                                             null: false
    t.string   "muuttaja",          limit: 50,                            default: "",  null: false
    t.integer  "inventointitunnus", limit: 4,                             default: 0,   null: false
  end

  add_index "sarjanumeroseuranta", ["yhtio", "lisatieto"], name: "yhtio_lisatieto", type: :fulltext
  add_index "sarjanumeroseuranta", ["yhtio", "perheid"], name: "perheid", using: :btree
  add_index "sarjanumeroseuranta", ["yhtio", "sarjanumero"], name: "yhtio_sarjanumero", using: :btree
  add_index "sarjanumeroseuranta", ["yhtio", "tuoteno", "myyntirivitunnus"], name: "yhtio_myyntirivi", using: :btree
  add_index "sarjanumeroseuranta", ["yhtio", "tuoteno", "ostorivitunnus"], name: "yhtio_ostorivi", using: :btree
  add_index "sarjanumeroseuranta", ["yhtio", "tuoteno", "sarjanumero"], name: "yhtio_tuoteno_sarjanumero", using: :btree
  add_index "sarjanumeroseuranta", ["yhtio", "tuoteno", "siirtorivitunnus"], name: "yhtio_siirtorivitunnus", using: :btree
  add_index "sarjanumeroseuranta", ["yhtio", "tuoteno"], name: "yhtio_tuoteno", using: :btree

  create_table "sarjanumeroseuranta_arvomuutos", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",             limit: 5,                              default: "",  null: false
    t.integer  "sarjanumerotunnus", limit: 8,                              default: 0,   null: false
    t.decimal  "arvomuutos",                      precision: 16, scale: 6, default: 0.0, null: false
    t.text     "selite",            limit: 65535
    t.string   "laatija",           limit: 50,                             default: "",  null: false
    t.datetime "luontiaika",                                                             null: false
  end

  create_table "suorituksen_kohdistus", primary_key: "tunnus", force: :cascade do |t|
    t.string  "yhtio",          limit: 5,                          default: "", null: false
    t.integer "suoritustunnus", limit: 4
    t.integer "laskutunnus",    limit: 4
    t.decimal "kaatosumma",               precision: 12, scale: 2
    t.date    "kohdistuspvm"
    t.date    "kirjauspvm"
  end

  add_index "suorituksen_kohdistus", ["yhtio", "laskutunnus"], name: "laskutunnus_index", using: :btree
  add_index "suorituksen_kohdistus", ["yhtio", "suoritustunnus"], name: "suoritustunnus_index", using: :btree

  create_table "suoritus", primary_key: "tunnus", force: :cascade do |t|
    t.string  "yhtio",          limit: 5,                              default: "",  null: false
    t.string  "tilino",         limit: 35,                             default: "",  null: false
    t.string  "tilino_maksaja", limit: 35,                             default: "",  null: false
    t.string  "nimi_maksaja",   limit: 12,                             default: "",  null: false
    t.string  "viite",          limit: 25,                             default: "",  null: false
    t.text    "viesti",         limit: 65535
    t.decimal "summa",                        precision: 12, scale: 2, default: 0.0, null: false
    t.string  "valkoodi",       limit: 3,                              default: "",  null: false
    t.decimal "kurssi",                       precision: 15, scale: 9, default: 0.0, null: false
    t.date    "maksupvm",                                                            null: false
    t.date    "kirjpvm",                                                             null: false
    t.date    "kohdpvm",                                                             null: false
    t.integer "asiakas_tunnus", limit: 4,                              default: 0,   null: false
    t.integer "ltunnus",        limit: 4,                              default: 0,   null: false
  end

  add_index "suoritus", ["ltunnus"], name: "tositerivit_index", using: :btree
  add_index "suoritus", ["yhtio", "asiakas_tunnus"], name: "yhtio_asiakastunnus", using: :btree
  add_index "suoritus", ["yhtio", "kohdpvm"], name: "yhtio_kohdpvm", using: :btree
  add_index "suoritus", ["yhtio", "viite"], name: "yhtio_viite", using: :btree

  create_table "suorituskykyloki", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",         limit: 5,                                   default: "",  null: false
    t.string   "skripti",       limit: 100,                                 default: "",  null: false
    t.datetime "suoritusalku",                                                            null: false
    t.datetime "suoritusloppu",                                                           null: false
    t.decimal  "suoritusaika",                     precision: 12, scale: 4, default: 0.0, null: false
    t.string   "laatija",       limit: 50,                                  default: "",  null: false
    t.datetime "luontiaika",                                                              null: false
    t.text     "request",       limit: 4294967295
    t.string   "iposoite",      limit: 15,                                  default: "",  null: false
  end

  add_index "suorituskykyloki", ["yhtio", "luontiaika"], name: "yhtio_luontiaika", using: :btree
  add_index "suorituskykyloki", ["yhtio", "skripti", "luontiaika"], name: "yhtio_skripti_luontiaika", using: :btree

  create_table "supplier_product_informations", force: :cascade do |t|
    t.string   "product_id",               limit: 100
    t.string   "product_name",             limit: 150
    t.string   "manufacturer_ean",         limit: 13
    t.string   "manufacturer_name",        limit: 100
    t.integer  "manufacturer_id",          limit: 4
    t.string   "manufacturer_part_number", limit: 100
    t.string   "supplier_name",            limit: 100
    t.integer  "supplier_id",              limit: 4
    t.string   "supplier_ean",             limit: 13
    t.string   "supplier_part_number",     limit: 100
    t.string   "product_status",           limit: 100
    t.string   "short_description",        limit: 250
    t.string   "description",              limit: 500
    t.string   "category_text1",           limit: 100
    t.string   "category_text2",           limit: 100
    t.string   "category_text3",           limit: 100
    t.string   "category_text4",           limit: 100
    t.integer  "category_idn",             limit: 4
    t.decimal  "net_price",                            precision: 16, scale: 6
    t.decimal  "net_retail_price",                     precision: 16, scale: 6
    t.integer  "available_quantity",       limit: 4
    t.date     "available_next_date"
    t.integer  "available_next_quantity",  limit: 4
    t.integer  "warranty_months",          limit: 4
    t.decimal  "gross_mass",                           precision: 8,  scale: 4
    t.boolean  "end_of_life",                                                   default: false, null: false
    t.boolean  "returnable",                                                    default: false, null: false
    t.boolean  "cancelable",                                                    default: false, null: false
    t.string   "warranty_text",            limit: 100
    t.string   "packaging_unit",           limit: 100
    t.decimal  "vat_rate",                             precision: 4,  scale: 2
    t.integer  "bid_price_id",             limit: 4
    t.string   "url_to_product",           limit: 150
    t.integer  "p_product_id",             limit: 4
    t.integer  "p_price_update",           limit: 4
    t.integer  "p_qty_update",             limit: 4
    t.datetime "p_added_date"
    t.datetime "p_last_update_date"
    t.string   "p_nakyvyys",               limit: 100
    t.integer  "p_tree_id",                limit: 4
    t.datetime "created_at",                                                                    null: false
    t.datetime "updated_at",                                                                    null: false
  end

  create_table "suuntalavat", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",              limit: 5,                            default: "",  null: false
    t.string   "tila",               limit: 1,                            default: "",  null: false
    t.string   "sscc",               limit: 150,                          default: "",  null: false
    t.string   "keikkatunnus",       limit: 150,                          default: "",  null: false
    t.string   "alkuhyllyalue",      limit: 5,                            default: "",  null: false
    t.string   "alkuhyllynro",       limit: 5,                            default: "",  null: false
    t.string   "alkuhyllyvali",      limit: 5,                            default: "",  null: false
    t.string   "alkuhyllytaso",      limit: 5,                            default: "",  null: false
    t.string   "loppuhyllyalue",     limit: 5,                            default: "",  null: false
    t.string   "loppuhyllynro",      limit: 5,                            default: "",  null: false
    t.string   "loppuhyllyvali",     limit: 5,                            default: "",  null: false
    t.string   "loppuhyllytaso",     limit: 5,                            default: "",  null: false
    t.integer  "tyyppi",             limit: 4,                            default: 0,   null: false
    t.integer  "keraysvyohyke",      limit: 4,                            default: 0,   null: false
    t.string   "usea_keraysvyohyke", limit: 1,                            default: "",  null: false
    t.string   "kaytettavyys",       limit: 1,                            default: "",  null: false
    t.string   "kasittelytapa",      limit: 1,                            default: "",  null: false
    t.string   "terminaalialue",     limit: 150,                          default: "",  null: false
    t.decimal  "korkeus",                        precision: 10, scale: 4, default: 0.0, null: false
    t.decimal  "paino",                          precision: 10, scale: 4, default: 0.0, null: false
    t.string   "laatija",            limit: 50,                           default: "",  null: false
    t.datetime "luontiaika",                                                            null: false
    t.datetime "muutospvm",                                                             null: false
    t.string   "muuttaja",           limit: 50,                           default: "",  null: false
  end

  add_index "suuntalavat", ["yhtio", "tila", "keraysvyohyke", "kaytettavyys"], name: "yhtio_tila_keraysvyohyke_kaytettavyys", using: :btree
  add_index "suuntalavat", ["yhtio", "tila", "keraysvyohyke", "keikkatunnus"], name: "yhtio_tila_keraysvyohyke_keikkatunnus", using: :btree
  add_index "suuntalavat", ["yhtio", "tila", "usea_keraysvyohyke", "kaytettavyys"], name: "usea_keraysvyohyke", using: :btree

  create_table "suuntalavat_saapuminen", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",      limit: 5,  default: "", null: false
    t.integer  "suuntalava", limit: 4,  default: 0,  null: false
    t.integer  "saapuminen", limit: 4,  default: 0,  null: false
    t.string   "laatija",    limit: 50, default: "", null: false
    t.datetime "luontiaika",                         null: false
    t.datetime "muutospvm",                          null: false
    t.string   "muuttaja",   limit: 50, default: "", null: false
  end

  add_index "suuntalavat_saapuminen", ["yhtio", "saapuminen"], name: "saapuminen", using: :btree
  add_index "suuntalavat_saapuminen", ["yhtio", "suuntalava", "saapuminen"], name: "suuntalavat_saapuminen", using: :btree

  create_table "synclog", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",        limit: 5,     default: "", null: false
    t.string   "taulu",        limit: 20,    default: "", null: false
    t.integer  "tauluntunnus", limit: 4,     default: 0,  null: false
    t.string   "tapa",         limit: 10,    default: "", null: false
    t.text     "viesti",       limit: 65535
    t.string   "laatija",      limit: 50,    default: "", null: false
    t.datetime "luontiaika",                              null: false
  end

  create_table "tallennetut_parametrit", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",      limit: 5,          default: "", null: false
    t.string   "kuka",       limit: 50,         default: "", null: false
    t.string   "nimitys",    limit: 100,        default: "", null: false
    t.string   "sovellus",   limit: 100,        default: "", null: false
    t.text     "data",       limit: 4294967295
    t.string   "laatija",    limit: 50,         default: "", null: false
    t.datetime "luontiaika",                                 null: false
  end

  add_index "tallennetut_parametrit", ["yhtio", "kuka", "sovellus", "nimitys"], name: "muisti", unique: true, using: :btree

  create_table "tapahtuma", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",      limit: 5,                              default: "",  null: false
    t.string   "tuoteno",    limit: 60,                             default: "",  null: false
    t.string   "laji",       limit: 15,                             default: "",  null: false
    t.decimal  "kpl",                      precision: 12, scale: 2, default: 0.0, null: false
    t.decimal  "hinta",                    precision: 16, scale: 6, default: 0.0, null: false
    t.decimal  "kplhinta",                 precision: 16, scale: 6, default: 0.0, null: false
    t.text     "selite",     limit: 65535
    t.string   "laatija",    limit: 50,                             default: "",  null: false
    t.datetime "laadittu",                                                        null: false
    t.integer  "rivitunnus", limit: 4,                              default: 0,   null: false
    t.string   "hyllyalue",  limit: 5,                              default: "",  null: false
    t.string   "hyllynro",   limit: 5,                              default: "",  null: false
    t.string   "hyllytaso",  limit: 5,                              default: "",  null: false
    t.string   "hyllyvali",  limit: 5,                              default: "",  null: false
    t.integer  "varasto",    limit: 4
  end

  add_index "tapahtuma", ["yhtio", "laadittu", "hyllyalue", "hyllynro"], name: "yhtio_laadittu_hyllyalue_hyllynro", using: :btree
  add_index "tapahtuma", ["yhtio", "laji", "laadittu"], name: "yhtio_laji_laadittu", using: :btree
  add_index "tapahtuma", ["yhtio", "laji", "rivitunnus"], name: "yhtio_laji_rivitunnus", using: :btree
  add_index "tapahtuma", ["yhtio", "laji", "tuoteno"], name: "yhtio_laji_tuoteno", using: :btree
  add_index "tapahtuma", ["yhtio", "tuoteno", "laadittu"], name: "yhtio_tuote_laadittu", using: :btree

  create_table "taric_veroperusteet", primary_key: "tunnus", force: :cascade do |t|
    t.string  "laji",                   limit: 8,                           default: "",  null: false
    t.string  "nimike",                 limit: 10,                          default: "",  null: false
    t.string  "lisakoodin_tyyppi",      limit: 1,                           default: "",  null: false
    t.integer "lisakoodi",              limit: 4,                           default: 0,   null: false
    t.date    "voim_alkupvm",                                                             null: false
    t.date    "voim_loppupvm",                                                            null: false
    t.integer "toimenpide_id",          limit: 4,                           default: 0,   null: false
    t.integer "toimenpidetyyppi",       limit: 4,                           default: 0,   null: false
    t.string  "maa_ryhma",              limit: 4,                           default: "",  null: false
    t.decimal "maara",                             precision: 10, scale: 3, default: 0.0, null: false
    t.string  "rahayksikko",            limit: 3,                           default: "",  null: false
    t.string  "paljousyksikko",         limit: 3,                           default: "",  null: false
    t.string  "paljousyksikko_muunnin", limit: 1,                           default: "",  null: false
    t.string  "duty_expr_id",           limit: 2,                           default: "",  null: false
    t.integer "kiintionumero",          limit: 4,                           default: 0,   null: false
    t.string  "alaviitteen_tyyppi",     limit: 2,                           default: "",  null: false
    t.integer "alaviitenumero",         limit: 4,                           default: 0,   null: false
  end

  add_index "taric_veroperusteet", ["laji", "nimike", "maa_ryhma"], name: "nimike_index", using: :btree
  add_index "taric_veroperusteet", ["laji", "toimenpide_id"], name: "fyysinen_avain_index", using: :btree

  create_table "taso", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",                       limit: 5,                            default: "",  null: false
    t.string   "tyyppi",                      limit: 1,                            default: "",  null: false
    t.string   "summattava_taso",             limit: 150,                          default: "",  null: false
    t.string   "taso",                        limit: 20,                           default: "",  null: false
    t.string   "nimi",                        limit: 100,                          default: "",  null: false
    t.decimal  "oletusarvo",                              precision: 12, scale: 2, default: 0.0, null: false
    t.decimal  "kerroin",                                 precision: 12, scale: 2, default: 0.0, null: false
    t.decimal  "jakaja",                                  precision: 12, scale: 2, default: 0.0, null: false
    t.string   "kumulatiivinen",              limit: 1,                            default: "",  null: false
    t.string   "kayttotarkoitus",             limit: 1,                            default: "",  null: false
    t.string   "poisto_vastatili",            limit: 6,                            default: "",  null: false
    t.string   "poistoero_tili",              limit: 6,                            default: "",  null: false
    t.string   "poistoero_vastatili",         limit: 6,                            default: "",  null: false
    t.string   "planned_depreciation_type",   limit: 1,                            default: "",  null: false
    t.decimal  "planned_depreciation_amount",             precision: 16, scale: 6, default: 0.0, null: false
    t.string   "btl_depreciation_type",       limit: 1,                            default: "",  null: false
    t.decimal  "btl_depreciation_amount",                 precision: 16, scale: 6, default: 0.0, null: false
    t.string   "laatija",                     limit: 50,                           default: "",  null: false
    t.datetime "luontiaika",                                                                     null: false
    t.datetime "muutospvm",                                                                      null: false
    t.string   "muuttaja",                    limit: 50,                           default: "",  null: false
  end

  add_index "taso", ["yhtio", "tyyppi", "taso"], name: "yhtio_tyyppi_taso_index", unique: true, using: :btree

  create_table "tilausrivi", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",                 limit: 5,                              default: "",   null: false
    t.string   "tyyppi",                limit: 1,                              default: "",   null: false
    t.date     "toimaika",                                                                    null: false
    t.date     "kerayspvm",                                                                   null: false
    t.integer  "otunnus",               limit: 4,                              default: 0,    null: false
    t.string   "tuoteno",               limit: 60,                             default: "",   null: false
    t.integer  "try",                   limit: 4,                              default: 0,    null: false
    t.integer  "osasto",                limit: 4,                              default: 0,    null: false
    t.string   "nimitys",               limit: 100,                            default: "",   null: false
    t.decimal  "kpl",                                 precision: 12, scale: 2, default: 0.0,  null: false
    t.decimal  "kpl2",                                precision: 12, scale: 2, default: 0.0,  null: false
    t.decimal  "tilkpl",                              precision: 12, scale: 2, default: 0.0,  null: false
    t.string   "yksikko",               limit: 3,                              default: "",   null: false
    t.decimal  "varattu",                             precision: 12, scale: 2, default: 0.0,  null: false
    t.decimal  "jt",                                  precision: 12, scale: 2, default: 0.0,  null: false
    t.decimal  "hinta",                               precision: 16, scale: 6, default: 0.0,  null: false
    t.decimal  "hinta_valuutassa",                    precision: 16, scale: 6, default: 0.0,  null: false
    t.decimal  "hinta_alkuperainen",                  precision: 16, scale: 6, default: 0.0,  null: false
    t.decimal  "alv",                                 precision: 5,  scale: 2, default: 0.0,  null: false
    t.decimal  "rivihinta",                           precision: 16, scale: 6, default: 0.0,  null: false
    t.decimal  "rivihinta_valuutassa",                precision: 16, scale: 6, default: 0.0,  null: false
    t.decimal  "erikoisale",                          precision: 5,  scale: 2, default: 0.0,  null: false
    t.decimal  "erikoisale_saapuminen",               precision: 5,  scale: 2, default: 0.0,  null: false
    t.decimal  "ale1",                                precision: 5,  scale: 2, default: 0.0,  null: false
    t.decimal  "ale2",                                precision: 5,  scale: 2, default: 0.0,  null: false
    t.decimal  "ale3",                                precision: 5,  scale: 2, default: 0.0,  null: false
    t.decimal  "kate",                                precision: 16, scale: 6, default: 0.0,  null: false
    t.decimal  "kate_korjattu",                       precision: 16, scale: 6
    t.decimal  "valmistus_painoarvo",                 precision: 9,  scale: 8
    t.text     "kommentti",             limit: 65535
    t.text     "ale_peruste",           limit: 65535
    t.string   "laatija",               limit: 50,                             default: "",   null: false
    t.datetime "laadittu",                                                                    null: false
    t.string   "keratty",               limit: 50,                             default: "",   null: false
    t.datetime "kerattyaika",                                                                 null: false
    t.string   "toimitettu",            limit: 50,                             default: "",   null: false
    t.datetime "toimitettuaika",                                                              null: false
    t.string   "laskutettu",            limit: 50,                             default: "",   null: false
    t.date     "laskutettuaika",                                                              null: false
    t.string   "var",                   limit: 1,                              default: "",   null: false
    t.string   "var2",                  limit: 5,                              default: "",   null: false
    t.string   "netto",                 limit: 1,                              default: "",   null: false
    t.integer  "perheid",               limit: 4,                              default: 0,    null: false
    t.integer  "perheid2",              limit: 4,                              default: 0,    null: false
    t.string   "hyllyalue",             limit: 5,                              default: "",   null: false
    t.string   "hyllynro",              limit: 5,                              default: "",   null: false
    t.string   "hyllytaso",             limit: 5,                              default: "",   null: false
    t.string   "hyllyvali",             limit: 5,                              default: "",   null: false
    t.integer  "suuntalava",            limit: 4,                              default: 0,    null: false
    t.integer  "campaign_id",           limit: 4
    t.boolean  "varastoon",                                                    default: true, null: false
    t.decimal  "vahvistettu_maara",                   precision: 12, scale: 2
    t.text     "vahvistettu_kommentti", limit: 65535
    t.integer  "tilaajanrivinro",       limit: 4,                              default: 0,    null: false
    t.integer  "jaksotettu",            limit: 4,                              default: 0,    null: false
    t.integer  "varasto",               limit: 4
    t.integer  "uusiotunnus",           limit: 4,                              default: 0,    null: false
  end

  add_index "tilausrivi", ["yhtio", "laadittu"], name: "yhtio_laadittu", using: :btree
  add_index "tilausrivi", ["yhtio", "otunnus"], name: "yhtio_otunnus", using: :btree
  add_index "tilausrivi", ["yhtio", "perheid2"], name: "yhtio_perheid2", using: :btree
  add_index "tilausrivi", ["yhtio", "suuntalava"], name: "suuntalava_index", using: :btree
  add_index "tilausrivi", ["yhtio", "tyyppi", "kerattyaika"], name: "yhtio_tyyppi_kerattyaika", using: :btree
  add_index "tilausrivi", ["yhtio", "tyyppi", "laskutettuaika"], name: "yhtio_tyyppi_laskutettuaika", using: :btree
  add_index "tilausrivi", ["yhtio", "tyyppi", "osasto", "try", "laadittu"], name: "yhtio_tyyppi_osasto_try_laadittu", using: :btree
  add_index "tilausrivi", ["yhtio", "tyyppi", "osasto", "try", "laskutettuaika"], name: "yhtio_tyyppi_osasto_try_laskutettuaika", using: :btree
  add_index "tilausrivi", ["yhtio", "tyyppi", "toimitettuaika"], name: "yhtio_tyyppi_toimitettuaika", using: :btree
  add_index "tilausrivi", ["yhtio", "tyyppi", "tuoteno", "kerayspvm"], name: "yhtio_tyyppi_tuoteno_kerayspvm", using: :btree
  add_index "tilausrivi", ["yhtio", "tyyppi", "tuoteno", "laadittu"], name: "yhtio_tyyppi_tuoteno_laadittu", using: :btree
  add_index "tilausrivi", ["yhtio", "tyyppi", "tuoteno", "laskutettuaika"], name: "yhtio_tyyppi_tuoteno_laskutettuaika", using: :btree
  add_index "tilausrivi", ["yhtio", "tyyppi", "tuoteno", "varattu"], name: "yhtio_tyyppi_tuoteno_varattu", using: :btree
  add_index "tilausrivi", ["yhtio", "tyyppi", "var", "keratty", "kerattyaika", "uusiotunnus"], name: "yhtio_tyyppi_var_keratty_kerattyaika_uusiotunnus", using: :btree
  add_index "tilausrivi", ["yhtio", "uusiotunnus"], name: "uusiotunnus_index", using: :btree

  create_table "tilausrivin_lisatiedot", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",                     limit: 5,                             default: "",    null: false
    t.integer  "tilausrivitunnus",          limit: 4,                             default: 0,     null: false
    t.integer  "tiliointirivitunnus",       limit: 4,                             default: 0,     null: false
    t.integer  "tilausrivilinkki",          limit: 4,                             default: 0,     null: false
    t.integer  "toimittajan_tunnus",        limit: 4,                             default: 0,     null: false
    t.decimal  "kulun_kohdemaan_alv",                     precision: 5, scale: 2, default: 0.0,   null: false
    t.string   "kulun_kohdemaa",            limit: 2,                             default: "",    null: false
    t.text     "hankintakulut",             limit: 65535
    t.integer  "asiakkaan_positio",         limit: 4,                             default: 0,     null: false
    t.string   "positio",                   limit: 20,                            default: "",    null: false
    t.integer  "palautus_varasto",          limit: 4,                             default: 0,     null: false
    t.string   "pituus",                    limit: 100,                           default: "",    null: false
    t.string   "leveys",                    limit: 100,                           default: "",    null: false
    t.string   "pidin",                     limit: 100,                           default: "",    null: false
    t.string   "viiste",                    limit: 100,                           default: "",    null: false
    t.string   "porauskuvio",               limit: 100,                           default: "",    null: false
    t.string   "niitti",                    limit: 100,                           default: "",    null: false
    t.integer  "autoid",                    limit: 4,                             default: 0,     null: false
    t.string   "rekisterinumero",           limit: 7,                             default: "",    null: false
    t.string   "ei_nayteta",                limit: 1,                             default: "",    null: false
    t.integer  "alunperin_puute",           limit: 4,                             default: 0,     null: false
    t.string   "osto_vai_hyvitys",          limit: 1,                             default: "",    null: false
    t.string   "sistyomaarays_sarjatunnus", limit: 255,                           default: "",    null: false
    t.string   "suoraan_laskutukseen",      limit: 1,                             default: "",    null: false
    t.boolean  "erikoistoimitus_myynti",                                          default: false, null: false
    t.integer  "vanha_otunnus",             limit: 4,                             default: 0,     null: false
    t.string   "omalle_tilaukselle",        limit: 1,                             default: "",    null: false
    t.string   "ohita_kerays",              limit: 1,                             default: "",    null: false
    t.string   "jt_manual",                 limit: 1,                             default: "",    null: false
    t.decimal  "poikkeava_tulliprosentti",                precision: 5, scale: 2
    t.integer  "jarjestys",                 limit: 4,                             default: 0,     null: false
    t.date     "sopimus_alkaa",                                                                   null: false
    t.date     "sopimus_loppuu",                                                                  null: false
    t.text     "sopimuksen_lisatieto1",     limit: 65535
    t.text     "sopimuksen_lisatieto2",     limit: 65535
    t.date     "suoratoimitettuaika",                                                             null: false
    t.datetime "toimitusaika_paivitetty",                                                         null: false
    t.string   "kohde_hyllyalue",           limit: 5,                             default: "",    null: false
    t.string   "kohde_hyllynro",            limit: 5,                             default: "",    null: false
    t.string   "kohde_hyllyvali",           limit: 5,                             default: "",    null: false
    t.string   "kohde_hyllytaso",           limit: 5,                             default: "",    null: false
    t.string   "korvamerkinta",             limit: 100,                           default: "",    null: false
    t.integer  "tullinimike",               limit: 4,                             default: 0,     null: false
    t.datetime "luontiaika",                                                                      null: false
    t.string   "laatija",                   limit: 50,                            default: "",    null: false
    t.datetime "muutospvm",                                                                       null: false
    t.string   "muuttaja",                  limit: 50,                            default: "",    null: false
  end

  add_index "tilausrivin_lisatiedot", ["yhtio", "asiakkaan_positio"], name: "yhtio_asiakkaan_positio", using: :btree
  add_index "tilausrivin_lisatiedot", ["yhtio", "kohde_hyllyalue", "kohde_hyllynro", "kohde_hyllyvali", "kohde_hyllytaso"], name: "kohde_hyllypaikka", using: :btree
  add_index "tilausrivin_lisatiedot", ["yhtio", "tilausrivilinkki"], name: "tilausrivilinkki", using: :btree
  add_index "tilausrivin_lisatiedot", ["yhtio", "tilausrivitunnus"], name: "tilausrivitunnus", unique: true, using: :btree
  add_index "tilausrivin_lisatiedot", ["yhtio", "vanha_otunnus"], name: "yhtio_vanhaotunnus", using: :btree

  create_table "tili", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",               limit: 5,                           default: "", null: false
    t.string   "tilino",              limit: 6,                           default: "", null: false
    t.string   "sisainen_taso",       limit: 20,                          default: "", null: false
    t.string   "ulkoinen_taso",       limit: 20,                          default: "", null: false
    t.string   "alv_taso",            limit: 20,                          default: "", null: false
    t.string   "evl_taso",            limit: 20,                          default: "", null: false
    t.string   "tulosseuranta_taso",  limit: 20,                          default: "", null: false
    t.string   "nimi",                limit: 100,                         default: "", null: false
    t.integer  "kustp",               limit: 4,                           default: 0,  null: false
    t.integer  "kohde",               limit: 4,                           default: 0,  null: false
    t.integer  "projekti",            limit: 4,                           default: 0,  null: false
    t.string   "toimijaliitos",       limit: 1,                           default: "", null: false
    t.integer  "tiliointi_tarkistus", limit: 4,                           default: 0,  null: false
    t.string   "manuaali_esto",       limit: 1,                           default: "", null: false
    t.decimal  "oletus_alv",                      precision: 5, scale: 2
    t.string   "laatija",             limit: 50,                          default: "", null: false
    t.datetime "luontiaika",                                                           null: false
    t.datetime "muutospvm",                                                            null: false
    t.string   "muuttaja",            limit: 50,                          default: "", null: false
  end

  add_index "tili", ["nimi"], name: "nimi", type: :fulltext
  add_index "tili", ["yhtio", "tilino"], name: "tili_index", using: :btree

  create_table "tilikaudet", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",           limit: 5,  default: "", null: false
    t.date     "tilikausi_alku",                          null: false
    t.date     "tilikausi_loppu",                         null: false
    t.integer  "avaava_tase",     limit: 4,  default: 0,  null: false
    t.string   "laatija",         limit: 50, default: "", null: false
    t.datetime "luontiaika",                              null: false
    t.datetime "muutospvm",                               null: false
    t.string   "muuttaja",        limit: 50, default: "", null: false
  end

  create_table "tiliointi", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",            limit: 5,                              default: "",  null: false
    t.string   "laatija",          limit: 50,                             default: "",  null: false
    t.datetime "laadittu",                                                              null: false
    t.integer  "ltunnus",          limit: 4,                              default: 0,   null: false
    t.string   "liitos",           limit: 1,                              default: "",  null: false
    t.integer  "liitostunnus",     limit: 4,                              default: 0,   null: false
    t.string   "tilino",           limit: 6,                              default: "",  null: false
    t.integer  "kustp",            limit: 4,                              default: 0,   null: false
    t.integer  "kohde",            limit: 4,                              default: 0,   null: false
    t.integer  "projekti",         limit: 4,                              default: 0,   null: false
    t.date     "tapvm",                                                                 null: false
    t.decimal  "summa",                          precision: 12, scale: 2, default: 0.0, null: false
    t.decimal  "summa_valuutassa",               precision: 12, scale: 2, default: 0.0, null: false
    t.string   "valkoodi",         limit: 3,                              default: "",  null: false
    t.text     "selite",           limit: 65535
    t.decimal  "vero",                           precision: 4,  scale: 2, default: 0.0, null: false
    t.string   "lukko",            limit: 1,                              default: "",  null: false
    t.string   "korjattu",         limit: 50,                             default: "",  null: false
    t.datetime "korjausaika",                                                           null: false
    t.integer  "tosite",           limit: 4,                              default: 0,   null: false
    t.integer  "commodity_id",     limit: 4
    t.integer  "aputunnus",        limit: 4,                              default: 0,   null: false
    t.integer  "tapahtumatunnus",  limit: 4,                              default: 0,   null: false
  end

  add_index "tiliointi", ["commodity_id"], name: "commodity_id", using: :btree
  add_index "tiliointi", ["ltunnus"], name: "tositerivit_index", using: :btree
  add_index "tiliointi", ["yhtio", "aputunnus"], name: "aputunnus_index", using: :btree
  add_index "tiliointi", ["yhtio", "tapahtumatunnus"], name: "yhtio_tapahtumatunnus", using: :btree
  add_index "tiliointi", ["yhtio", "tapvm", "tilino"], name: "yhtio_tapvm_tilino", using: :btree
  add_index "tiliointi", ["yhtio", "tilino", "tapvm"], name: "yhtio_tilino_tapvm", using: :btree
  add_index "tiliointi", ["yhtio", "tosite"], name: "tosite_index", using: :btree

  create_table "tiliointisaanto", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",       limit: 5,     default: "", null: false
    t.string   "tyyppi",      limit: 1,     default: "", null: false
    t.integer  "ttunnus",     limit: 4,     default: 0,  null: false
    t.string   "mintuote",    limit: 25,    default: "", null: false
    t.string   "maxtuote",    limit: 25,    default: "", null: false
    t.text     "kuvaus",      limit: 65535
    t.text     "kuvaus2",     limit: 65535
    t.string   "tilino",      limit: 6,     default: "", null: false
    t.integer  "kustp",       limit: 4,     default: 0,  null: false
    t.string   "alv",         limit: 1,     default: "", null: false
    t.integer  "toimipaikka", limit: 4,     default: 0,  null: false
    t.string   "hyvak1",      limit: 50,    default: "", null: false
    t.string   "hyvak2",      limit: 50,    default: "", null: false
    t.string   "hyvak3",      limit: 50,    default: "", null: false
    t.string   "hyvak4",      limit: 50,    default: "", null: false
    t.string   "hyvak5",      limit: 50,    default: "", null: false
    t.string   "vienti",      limit: 1,     default: "", null: false
    t.string   "laatija",     limit: 50,    default: "", null: false
    t.datetime "luontiaika",                             null: false
    t.datetime "muutospvm",                              null: false
    t.string   "muuttaja",    limit: 50,    default: "", null: false
  end

  create_table "tiliotedata", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",           limit: 5,     default: "", null: false
    t.integer  "aineisto",        limit: 4,     default: 0,  null: false
    t.string   "tilino",          limit: 35,    default: "", null: false
    t.date     "alku",                                       null: false
    t.date     "loppu",                                      null: false
    t.string   "tyyppi",          limit: 1,     default: "", null: false
    t.date     "kasitelty",                                  null: false
    t.string   "kuitattu",        limit: 50,    default: "", null: false
    t.datetime "kuitattuaika",                               null: false
    t.integer  "tiliointitunnus", limit: 8,     default: 0,  null: false
    t.text     "tieto",           limit: 65535
    t.integer  "perheid",         limit: 4,     default: 0,  null: false
  end

  add_index "tiliotedata", ["aineisto"], name: "aineisto_index", using: :btree
  add_index "tiliotedata", ["yhtio", "alku"], name: "yhtio_alku", using: :btree
  add_index "tiliotedata", ["yhtio", "perheid"], name: "perheid_index", using: :btree
  add_index "tiliotedata", ["yhtio", "tilino", "alku"], name: "yhtio_tilino_alku", using: :btree
  add_index "tiliotedata", ["yhtio", "tilino", "tyyppi", "tieto"], name: "yhtio_tilino_tyyppi_tieto", length: {"yhtio"=>nil, "tilino"=>nil, "tyyppi"=>nil, "tieto"=>150}, using: :btree
  add_index "tiliotedata", ["yhtio", "tiliointitunnus"], name: "yhtio_tiliointitunnus", using: :btree

  create_table "tiliotesaanto", primary_key: "tunnus", force: :cascade do |t|
    t.string  "yhtio",       limit: 5,   default: "", null: false
    t.string  "pankkitili",  limit: 35,  default: "", null: false
    t.string  "koodi",       limit: 3,   default: "", null: false
    t.string  "koodiselite", limit: 35,  default: "", null: false
    t.string  "nimitieto",   limit: 35,  default: "", null: false
    t.string  "selite",      limit: 100, default: "", null: false
    t.string  "erittely",    limit: 1,   default: "", null: false
    t.string  "tilino",      limit: 6,   default: "", null: false
    t.string  "tilino2",     limit: 6,   default: "", null: false
    t.integer "kustp",       limit: 4,   default: 0,  null: false
    t.integer "kustp2",      limit: 4,   default: 0,  null: false
  end

  create_table "toimi", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",                        limit: 5,                             default: "",  null: false
    t.string   "nimi",                         limit: 60,                            default: "",  null: false
    t.string   "nimitark",                     limit: 60,                            default: "",  null: false
    t.string   "osoite",                       limit: 45,                            default: "",  null: false
    t.string   "osoitetark",                   limit: 45,                            default: "",  null: false
    t.string   "postino",                      limit: 15,                            default: "",  null: false
    t.string   "postitp",                      limit: 45,                            default: "",  null: false
    t.string   "maa",                          limit: 2,                             default: "",  null: false
    t.string   "puhelin",                      limit: 130,                           default: "",  null: false
    t.string   "fax",                          limit: 30,                            default: "",  null: false
    t.string   "email",                        limit: 100,                           default: "",  null: false
    t.string   "toimittajaryhma",              limit: 150,                           default: "",  null: false
    t.string   "kuljetus",                     limit: 150,                           default: "",  null: false
    t.string   "toimitusehto",                 limit: 35,                            default: "",  null: false
    t.string   "huolitsija",                   limit: 35,                            default: "",  null: false
    t.string   "maksuteksti",                  limit: 35,                            default: "",  null: false
    t.string   "jakelu",                       limit: 35,                            default: "",  null: false
    t.string   "yhteyshenkilo",                limit: 35,                            default: "",  null: false
    t.string   "kieli",                        limit: 2,                             default: "",  null: false
    t.text     "fakta",                        limit: 65535
    t.string   "pankki_haltija",               limit: 60,                            default: "",  null: false
    t.string   "tilinumero",                   limit: 14,                            default: "",  null: false
    t.string   "pankki1",                      limit: 35,                            default: "",  null: false
    t.string   "pankki2",                      limit: 35,                            default: "",  null: false
    t.string   "pankki3",                      limit: 35,                            default: "",  null: false
    t.string   "pankki4",                      limit: 35,                            default: "",  null: false
    t.text     "ohjeitapankille",              limit: 65535
    t.string   "ultilno_maa",                  limit: 2,                             default: "",  null: false
    t.string   "ultilno",                      limit: 35,                            default: "",  null: false
    t.string   "swift",                        limit: 11,                            default: "",  null: false
    t.string   "clearing",                     limit: 35,                            default: "",  null: false
    t.string   "oletus_valkoodi",              limit: 3,                             default: "",  null: false
    t.decimal  "oletus_erapvm",                              precision: 3,           default: 0,   null: false
    t.integer  "oletus_toimaika",              limit: 4,                             default: 0,   null: false
    t.integer  "oletus_tilausvali",            limit: 4,                             default: 0,   null: false
    t.string   "oletus_suoraveloitus",         limit: 1,                             default: "",  null: false
    t.integer  "oletus_suoravel_pankki",       limit: 4,                             default: 0,   null: false
    t.decimal  "oletus_kapvm",                               precision: 3,           default: 0,   null: false
    t.decimal  "oletus_kapro",                               precision: 5, scale: 3, default: 0.0, null: false
    t.string   "oletus_hyvak1",                limit: 50,                            default: "",  null: false
    t.string   "oletus_hyvak2",                limit: 50,                            default: "",  null: false
    t.string   "oletus_hyvak3",                limit: 50,                            default: "",  null: false
    t.string   "oletus_hyvak4",                limit: 50,                            default: "",  null: false
    t.string   "oletus_hyvak5",                limit: 50,                            default: "",  null: false
    t.string   "oletus_hyvaksynnanmuutos",     limit: 1,                             default: "",  null: false
    t.string   "oletus_vienti",                limit: 1,                             default: "",  null: false
    t.string   "maa_lahetys",                  limit: 2,                             default: "",  null: false
    t.integer  "kauppatapahtuman_luonne",      limit: 4,                             default: 0,   null: false
    t.integer  "kuljetusmuoto",                limit: 4,                             default: 0,   null: false
    t.decimal  "oletus_kulupros",                            precision: 5, scale: 2, default: 0.0, null: false
    t.string   "kulujen_laskeminen_hintoihin", limit: 1,                             default: "",  null: false
    t.string   "edi_palvelin",                 limit: 50,                            default: "",  null: false
    t.string   "edi_kayttaja",                 limit: 50,                            default: "",  null: false
    t.string   "edi_salasana",                 limit: 50,                            default: "",  null: false
    t.string   "edi_kuvaus",                   limit: 50,                            default: "",  null: false
    t.string   "edi_polku",                    limit: 50,                            default: "",  null: false
    t.string   "asn_sanomat",                  limit: 1,                             default: "",  null: false
    t.string   "konserniyhtio",                limit: 1,                             default: "",  null: false
    t.string   "tilino",                       limit: 6,                             default: "",  null: false
    t.integer  "kustannuspaikka",              limit: 4,                             default: 0,   null: false
    t.integer  "kohde",                        limit: 4,                             default: 0,   null: false
    t.integer  "projekti",                     limit: 4,                             default: 0,   null: false
    t.string   "tilino_alv",                   limit: 6,                             default: "",  null: false
    t.string   "verovelvollinen",              limit: 2,                             default: "",  null: false
    t.string   "selaus",                       limit: 8,                             default: "",  null: false
    t.string   "ytunnus",                      limit: 15,                            default: "",  null: false
    t.string   "ovttunnus",                    limit: 25,                            default: "",  null: false
    t.string   "toimittajanro",                limit: 20,                            default: "",  null: false
    t.string   "maksukielto",                  limit: 1,                             default: "",  null: false
    t.string   "laskun_erittely",              limit: 1,                             default: "",  null: false
    t.string   "tyyppi",                       limit: 1,                             default: "",  null: false
    t.string   "tyyppi_tieto",                 limit: 100,                           default: "",  null: false
    t.string   "pikaperustus",                 limit: 1,                             default: "",  null: false
    t.integer  "hintojenpaivityssykli",        limit: 4,                             default: 0,   null: false
    t.string   "suoratoimitus",                limit: 1,                             default: "",  null: false
    t.string   "tehdas_saldo_tarkistus",       limit: 1,                             default: "",  null: false
    t.string   "sahkoinen_automaattituloutus", limit: 1,                             default: "",  null: false
    t.string   "ostotilauksen_kasittely",      limit: 1,                             default: "",  null: false
    t.string   "laatija",                      limit: 50,                            default: "",  null: false
    t.datetime "luontiaika",                                                                       null: false
    t.datetime "muutospvm",                                                                        null: false
    t.string   "muuttaja",                     limit: 50,                            default: "",  null: false
  end

  add_index "toimi", ["yhtio", "toimittajanro"], name: "toimittajanro_index", using: :btree
  add_index "toimi", ["yhtio", "ytunnus"], name: "ytunnus_index", using: :btree

  create_table "toimittajaalennus", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",       limit: 5,                          default: "",  null: false
    t.string   "tuoteno",     limit: 60,                         default: "",  null: false
    t.string   "ryhma",       limit: 15,                         default: "",  null: false
    t.integer  "toimittaja",  limit: 4,                          default: 0,   null: false
    t.string   "ytunnus",     limit: 15,                         default: "",  null: false
    t.decimal  "alennus",                precision: 5, scale: 2, default: 0.0, null: false
    t.integer  "alennuslaji", limit: 4,                          default: 1,   null: false
    t.integer  "minkpl",      limit: 4,                          default: 0,   null: false
    t.string   "monikerta",   limit: 1,                          default: "",  null: false
    t.date     "alkupvm",                                                      null: false
    t.date     "loppupvm",                                                     null: false
    t.string   "laatija",     limit: 50,                         default: "",  null: false
    t.datetime "luontiaika",                                                   null: false
    t.datetime "muutospvm",                                                    null: false
    t.string   "muuttaja",    limit: 50,                         default: "",  null: false
  end

  add_index "toimittajaalennus", ["yhtio", "toimittaja", "ryhma"], name: "yhtio_toimittaja_ryhma", using: :btree
  add_index "toimittajaalennus", ["yhtio", "toimittaja", "tuoteno"], name: "yhtio_toimittaja_tuoteno", using: :btree
  add_index "toimittajaalennus", ["yhtio", "tuoteno"], name: "yhtio_tuoteno", using: :btree
  add_index "toimittajaalennus", ["yhtio", "ytunnus", "ryhma"], name: "yhtio_ytunnus_ryhma", using: :btree
  add_index "toimittajaalennus", ["yhtio", "ytunnus", "tuoteno"], name: "yhtio_ytunnus_tuoteno", using: :btree

  create_table "toimittajahinta", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",      limit: 5,                           default: "",  null: false
    t.string   "tuoteno",    limit: 60,                          default: "",  null: false
    t.string   "ryhma",      limit: 15,                          default: "",  null: false
    t.integer  "toimittaja", limit: 4,                           default: 0,   null: false
    t.string   "ytunnus",    limit: 15,                          default: "",  null: false
    t.decimal  "hinta",                 precision: 16, scale: 6, default: 0.0, null: false
    t.string   "valkoodi",   limit: 3,                           default: "",  null: false
    t.integer  "minkpl",     limit: 4,                           default: 0,   null: false
    t.integer  "maxkpl",     limit: 4,                           default: 0,   null: false
    t.date     "alkupvm",                                                      null: false
    t.date     "loppupvm",                                                     null: false
    t.string   "laji",       limit: 1,                           default: "",  null: false
    t.string   "laatija",    limit: 50,                          default: "",  null: false
    t.datetime "luontiaika",                                                   null: false
    t.datetime "muutospvm",                                                    null: false
    t.string   "muuttaja",   limit: 50,                          default: "",  null: false
  end

  add_index "toimittajahinta", ["yhtio", "toimittaja", "ryhma"], name: "yhtio_toimittaja_ryhma", using: :btree
  add_index "toimittajahinta", ["yhtio", "toimittaja", "tuoteno"], name: "yhtio_toimittaja_tuoteno", using: :btree
  add_index "toimittajahinta", ["yhtio", "tuoteno"], name: "yhtio_tuoteno", using: :btree
  add_index "toimittajahinta", ["yhtio", "ytunnus", "ryhma"], name: "yhtio_ytunnus_ryhma", using: :btree
  add_index "toimittajahinta", ["yhtio", "ytunnus", "tuoteno"], name: "yhtio_ytunnus_tuoteno", using: :btree

  create_table "toimitustapa", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",                            limit: 5,                            default: "",  null: false
    t.string   "selite",                           limit: 50,                           default: "",  null: false
    t.string   "lahdon_selite",                    limit: 150,                          default: "",  null: false
    t.string   "virallinen_selite",                limit: 150,                          default: "",  null: false
    t.string   "tulostustapa",                     limit: 1,                            default: "",  null: false
    t.string   "rahtikirja",                       limit: 50,                           default: "",  null: false
    t.string   "logy_rahtikirjanumerot",           limit: 1,                            default: "",  null: false
    t.string   "osoitelappu",                      limit: 50,                           default: "",  null: false
    t.string   "rahdinkuljettaja",                 limit: 40,                           default: "",  null: false
    t.string   "rahti_tuotenumero",                limit: 60,                           default: "",  null: false
    t.string   "sopimusnro",                       limit: 50,                           default: "",  null: false
    t.string   "rahtikirjakopio_email",            limit: 150,                          default: "",  null: false
    t.decimal  "jvkulu",                                       precision: 5,  scale: 2, default: 0.0, null: false
    t.string   "jvkielto",                         limit: 1,                            default: "",  null: false
    t.string   "vak_kielto",                       limit: 50,                           default: "",  null: false
    t.string   "vaihtoehtoinen_vak_toimitustapa",  limit: 50,                           default: "",  null: false
    t.string   "erikoispakkaus_kielto",            limit: 1,                            default: "",  null: false
    t.string   "nouto",                            limit: 1,                            default: "",  null: false
    t.string   "lauantai",                         limit: 1,                            default: "",  null: false
    t.decimal  "erilliskasiteltavakulu",                       precision: 5,  scale: 2, default: 0.0, null: false
    t.string   "merahti",                          limit: 1,                            default: "",  null: false
    t.string   "kuljetusvakuutus_tuotenumero",     limit: 60,                           default: "",  null: false
    t.decimal  "kuljetusvakuutus",                             precision: 5,  scale: 2, default: 0.0, null: false
    t.string   "kuljetusvakuutus_tyyppi",          limit: 1,                            default: "",  null: false
    t.string   "extranet",                         limit: 1,                            default: "",  null: false
    t.string   "ei_pakkaamoa",                     limit: 1,                            default: "",  null: false
    t.string   "erittely",                         limit: 1,                            default: "",  null: false
    t.string   "uudet_pakkaustiedot",              limit: 1,                            default: "",  null: false
    t.string   "lajittelupiste",                   limit: 150,                          default: "",  null: false
    t.decimal  "kuluprosentti",                                precision: 8,  scale: 3, default: 0.0, null: false
    t.string   "toim_ovttunnus",                   limit: 25,                           default: "",  null: false
    t.string   "toim_nimi",                        limit: 60,                           default: "",  null: false
    t.string   "toim_nimitark",                    limit: 60,                           default: "",  null: false
    t.string   "toim_osoite",                      limit: 55,                           default: "",  null: false
    t.string   "toim_postino",                     limit: 15,                           default: "",  null: false
    t.string   "toim_postitp",                     limit: 35,                           default: "",  null: false
    t.string   "toim_maa",                         limit: 35,                           default: "",  null: false
    t.string   "maa_maara",                        limit: 2,                            default: "",  null: false
    t.string   "sisamaan_kuljetus",                limit: 30,                           default: "",  null: false
    t.string   "sisamaan_kuljetus_kansallisuus",   limit: 2,                            default: "",  null: false
    t.integer  "sisamaan_kuljetusmuoto",           limit: 4,                            default: 0,   null: false
    t.integer  "kontti",                           limit: 4,                            default: 0,   null: false
    t.string   "aktiivinen_kuljetus",              limit: 30,                           default: "",  null: false
    t.string   "aktiivinen_kuljetus_kansallisuus", limit: 2,                            default: "",  null: false
    t.integer  "kauppatapahtuman_luonne",          limit: 4,                            default: 0,   null: false
    t.integer  "kuljetusmuoto",                    limit: 4,                            default: 0,   null: false
    t.string   "poistumistoimipaikka_koodi",       limit: 8,                            default: "",  null: false
    t.decimal  "ulkomaanlisa",                                 precision: 6,  scale: 2, default: 0.0, null: false
    t.string   "sallitut_maat",                    limit: 50,                           default: "",  null: false
    t.decimal  "lisakulu",                                     precision: 5,  scale: 2, default: 0.0, null: false
    t.decimal  "lisakulu_summa",                               precision: 12, scale: 2, default: 0.0, null: false
    t.integer  "jarjestys",                        limit: 4,                            default: 0,   null: false
    t.string   "laatija",                          limit: 50,                           default: "",  null: false
    t.datetime "luontiaika",                                                                          null: false
    t.datetime "muutospvm",                                                                           null: false
    t.string   "muuttaja",                         limit: 50,                           default: "",  null: false
  end

  add_index "toimitustapa", ["yhtio", "selite"], name: "selite_index", using: :btree
  add_index "toimitustapa", ["yhtio", "selite"], name: "yhtio_selite", unique: true, using: :btree

  create_table "toimitustavan_avainsanat", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",        limit: 5,   default: "",  null: false
    t.integer  "liitostunnus", limit: 4,   default: 0,   null: false
    t.string   "kieli",        limit: 2,   default: "0", null: false
    t.string   "laji",         limit: 150, default: "",  null: false
    t.text     "selite",       limit: 255
    t.text     "selitetark",   limit: 255
    t.string   "laatija",      limit: 50,  default: "",  null: false
    t.datetime "luontiaika",                             null: false
    t.string   "muuttaja",     limit: 50,  default: "",  null: false
    t.datetime "muutospvm",                              null: false
  end

  add_index "toimitustavan_avainsanat", ["yhtio", "kieli", "laji", "liitostunnus"], name: "yhtio__kieli_laji_liitostunnus", using: :btree
  add_index "toimitustavan_avainsanat", ["yhtio", "liitostunnus", "kieli", "laji"], name: "yhtio_liitostunnus_kieli_laji", using: :btree

  create_table "toimitustavan_lahdot", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",                limit: 5,   default: "",                    null: false
    t.integer  "lahdon_viikonpvm",     limit: 4,   default: 0,                     null: false
    t.time     "lahdon_kellonaika",                default: '2000-01-01 00:00:00', null: false
    t.time     "viimeinen_tilausaika",             default: '2000-01-01 00:00:00', null: false
    t.time     "kerailyn_aloitusaika",             default: '2000-01-01 00:00:00', null: false
    t.string   "terminaalialue",       limit: 150, default: "",                    null: false
    t.string   "asiakasluokka",        limit: 50,  default: "",                    null: false
    t.integer  "varasto",              limit: 4,   default: 0,                     null: false
    t.string   "aktiivi",              limit: 1,   default: "",                    null: false
    t.string   "ohjausmerkki",         limit: 70,  default: "",                    null: false
    t.integer  "liitostunnus",         limit: 4,   default: 0,                     null: false
    t.date     "alkupvm",                                                          null: false
    t.string   "laatija",              limit: 50,  default: "",                    null: false
    t.datetime "luontiaika",                                                       null: false
    t.datetime "muutospvm",                                                        null: false
    t.string   "muuttaja",             limit: 50,  default: "",                    null: false
  end

  create_table "toimitustavat_toimipaikat", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",               limit: 5,  default: "", null: false
    t.integer  "toimitustapa_tunnus", limit: 4,               null: false
    t.integer  "toimipaikka_tunnus",  limit: 4,               null: false
    t.string   "laatija",             limit: 50, default: "", null: false
    t.datetime "luontiaika",                                  null: false
    t.datetime "muutospvm",                                   null: false
    t.string   "muuttaja",            limit: 50, default: "", null: false
  end

  add_index "toimitustavat_toimipaikat", ["yhtio"], name: "yhtio_index", using: :btree

  create_table "transports", force: :cascade do |t|
    t.integer  "transportable_id",   limit: 4
    t.string   "transportable_type", limit: 255
    t.string   "transport_name",     limit: 60,  default: "", null: false
    t.string   "hostname",           limit: 255
    t.integer  "port",               limit: 4
    t.string   "username",           limit: 255
    t.string   "password",           limit: 255
    t.string   "path",               limit: 255
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.string   "filename",           limit: 255
    t.string   "encoding",           limit: 255
  end

  add_index "transports", ["transportable_id"], name: "index_transports_on_transportable_id", using: :btree

  create_table "tullinimike", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",         limit: 5,     default: "", null: false
    t.string   "cnkey",         limit: 20,    default: "", null: false
    t.string   "cn",            limit: 8,     default: "", null: false
    t.string   "dashes",        limit: 10,    default: "", null: false
    t.text     "dm",            limit: 65535
    t.string   "su",            limit: 20,    default: "", null: false
    t.string   "su_vientiilmo", limit: 3,     default: "", null: false
    t.string   "kieli",         limit: 2,     default: "", null: false
    t.string   "laatija",       limit: 50,    default: "", null: false
    t.datetime "luontiaika",                               null: false
    t.datetime "muutospvm",                                null: false
    t.string   "muuttaja",      limit: 50,    default: "", null: false
  end

  add_index "tullinimike", ["cn"], name: "tullinimike_cn", using: :btree

  create_table "tuote", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",                         limit: 5,                              default: "",  null: false
    t.string   "tuoteno",                       limit: 60,                             default: "",  null: false
    t.string   "nimitys",                       limit: 100,                            default: "",  null: false
    t.integer  "osasto",                        limit: 4,                              default: 0,   null: false
    t.integer  "try",                           limit: 4,                              default: 0,   null: false
    t.string   "tuotemerkki",                   limit: 30,                             default: "",  null: false
    t.string   "malli",                         limit: 100,                            default: "",  null: false
    t.string   "mallitarkenne",                 limit: 100,                            default: "",  null: false
    t.text     "kuvaus",                        limit: 65535
    t.text     "lyhytkuvaus",                   limit: 65535
    t.text     "mainosteksti",                  limit: 65535
    t.string   "aleryhma",                      limit: 15,                             default: "",  null: false
    t.string   "muuta",                         limit: 250,                            default: "",  null: false
    t.text     "tilausrivi_kommentti",          limit: 65535
    t.text     "kerayskommentti",               limit: 65535
    t.text     "purkukommentti",                limit: 65535
    t.text     "ostokommentti",                 limit: 65535
    t.decimal  "myyntihinta",                                 precision: 16, scale: 6, default: 0.0, null: false
    t.integer  "myyntihinta_maara",             limit: 4,                              default: 0,   null: false
    t.decimal  "kehahin",                                     precision: 16, scale: 6, default: 0.0, null: false
    t.decimal  "vihahin",                                     precision: 16, scale: 6, default: 0.0, null: false
    t.date     "vihapvm",                                                                            null: false
    t.integer  "myyntikate",                    limit: 4,                              default: 0,   null: false
    t.integer  "myymalakate",                   limit: 4,                              default: 0,   null: false
    t.integer  "nettokate",                     limit: 4,                              default: 0,   null: false
    t.string   "yksikko",                       limit: 10,                             default: "",  null: false
    t.string   "ei_saldoa",                     limit: 1,                              default: "",  null: false
    t.string   "kommentoitava",                 limit: 1,                              default: "",  null: false
    t.string   "tuotetyyppi",                   limit: 1,                              default: "",  null: false
    t.string   "myynninseuranta",               limit: 1,                              default: "",  null: false
    t.string   "hinnastoon",                    limit: 1,                              default: "",  null: false
    t.string   "sarjanumeroseuranta",           limit: 1,                              default: "",  null: false
    t.integer  "automaattinen_sarjanumerointi", limit: 1,                              default: 0,   null: false
    t.string   "suoratoimitus",                 limit: 1,                              default: "",  null: false
    t.string   "status",                        limit: 10,                             default: "",  null: false
    t.string   "yksin_kerailyalustalle",        limit: 1,                              default: "",  null: false
    t.integer  "keraysvyohyke",                 limit: 4,                              default: 0,   null: false
    t.string   "panttitili",                    limit: 1,                              default: "",  null: false
    t.string   "tilino",                        limit: 6,                              default: "",  null: false
    t.string   "tilino_eu",                     limit: 6,                              default: "",  null: false
    t.string   "tilino_ei_eu",                  limit: 6,                              default: "",  null: false
    t.string   "tilino_kaanteinen",             limit: 6,                              default: "",  null: false
    t.string   "tilino_marginaali",             limit: 6,                              default: "",  null: false
    t.string   "tilino_osto_marginaali",        limit: 6,                              default: "",  null: false
    t.string   "tilino_triang",                 limit: 6,                              default: "",  null: false
    t.integer  "kustp",                         limit: 4,                              default: 0,   null: false
    t.integer  "kohde",                         limit: 4,                              default: 0,   null: false
    t.integer  "projekti",                      limit: 4,                              default: 0,   null: false
    t.string   "laatija",                       limit: 50,                             default: "",  null: false
    t.datetime "luontiaika",                                                                         null: false
    t.datetime "muutospvm",                                                                          null: false
    t.string   "muuttaja",                      limit: 50,                             default: "",  null: false
    t.string   "eankoodi",                      limit: 20,                             default: "",  null: false
    t.date     "epakurantti25pvm",                                                                   null: false
    t.date     "epakurantti50pvm",                                                                   null: false
    t.date     "epakurantti75pvm",                                                                   null: false
    t.date     "epakurantti100pvm",                                                                  null: false
    t.decimal  "myymalahinta",                                precision: 16, scale: 6, default: 0.0, null: false
    t.decimal  "nettohinta",                                  precision: 16, scale: 6, default: 0.0, null: false
    t.decimal  "halytysraja",                                 precision: 12, scale: 2, default: 0.0, null: false
    t.decimal  "varmuus_varasto",                             precision: 12, scale: 2, default: 0.0, null: false
    t.decimal  "tilausmaara",                                 precision: 12, scale: 2, default: 0.0, null: false
    t.string   "ostoehdotus",                   limit: 1,                              default: "",  null: false
    t.string   "tahtituote",                    limit: 5,                              default: "",  null: false
    t.decimal  "tarrakerroin",                                precision: 5,  scale: 2, default: 0.0, null: false
    t.decimal  "tarrakpl",                                    precision: 4,            default: 0,   null: false
    t.decimal  "myynti_era",                                  precision: 12, scale: 2, default: 0.0, null: false
    t.decimal  "minimi_era",                                  precision: 12, scale: 2, default: 0.0, null: false
    t.string   "valmistuslinja",                limit: 150,                            default: "",  null: false
    t.integer  "valmistusaika_sekunneissa",     limit: 4,                              default: 0,   null: false
    t.string   "tullikohtelu",                  limit: 4,                              default: "",  null: false
    t.string   "tullinimike1",                  limit: 8,                              default: "",  null: false
    t.string   "tullinimike2",                  limit: 4,                              default: "",  null: false
    t.decimal  "toinenpaljous_muunnoskerroin",                precision: 12, scale: 2, default: 0.0, null: false
    t.text     "vienti",                        limit: 65535,                                        null: false
    t.decimal  "tuotekorkeus",                                precision: 10, scale: 4, default: 0.0, null: false
    t.decimal  "tuoteleveys",                                 precision: 10, scale: 4, default: 0.0, null: false
    t.decimal  "tuotesyvyys",                                 precision: 10, scale: 4, default: 0.0, null: false
    t.decimal  "tuotemassa",                                  precision: 12, scale: 4, default: 0.0, null: false
    t.string   "tuotekuva",                     limit: 50,                             default: "",  null: false
    t.string   "nakyvyys",                      limit: 100,                            default: "",  null: false
    t.decimal  "kuluprosentti",                               precision: 8,  scale: 3, default: 0.0, null: false
    t.string   "vakkoodi",                      limit: 100,                            default: "",  null: false
    t.string   "vakmaara",                      limit: 50,                             default: "",  null: false
    t.string   "leimahduspiste",                limit: 50,                             default: "",  null: false
    t.string   "meria_saastuttava",             limit: 50,                             default: "",  null: false
    t.integer  "vak_imdg_koodi",                limit: 4,                              default: 0,   null: false
    t.text     "kuljetusohje",                  limit: 65535
    t.string   "pakkausmateriaali",             limit: 50,                             default: "",  null: false
    t.decimal  "alv",                                         precision: 5,  scale: 2, default: 0.0, null: false
    t.integer  "myyjanro",                      limit: 4,                              default: 0,   null: false
    t.integer  "ostajanro",                     limit: 4,                              default: 0,   null: false
    t.integer  "tuotepaallikko",                limit: 4,                              default: 0,   null: false
  end

  add_index "tuote", ["nimitys"], name: "nimitys", type: :fulltext
  add_index "tuote", ["tuoteno"], name: "tuoteno", type: :fulltext
  add_index "tuote", ["yhtio", "aleryhma"], name: "yhtio_aleryhma", using: :btree
  add_index "tuote", ["yhtio", "eankoodi"], name: "yhtio_eankoodi_index", using: :btree
  add_index "tuote", ["yhtio", "myyjanro"], name: "yhtio_myyjanro", using: :btree
  add_index "tuote", ["yhtio", "osasto", "try"], name: "osasto_try_index", using: :btree
  add_index "tuote", ["yhtio", "status", "osasto", "try"], name: "yhtio_status_osasto_try", using: :btree
  add_index "tuote", ["yhtio", "try"], name: "yhtio_try_index", using: :btree
  add_index "tuote", ["yhtio", "tullinimike1", "tullinimike2"], name: "yhtio_tullinimike", using: :btree
  add_index "tuote", ["yhtio", "tuotemerkki"], name: "yhtio_tuotemerkki", using: :btree
  add_index "tuote", ["yhtio", "tuoteno"], name: "tuoteno_index", unique: true, using: :btree
  add_index "tuote", ["yhtio", "tuotetyyppi", "status"], name: "yhtio_tuotetyyppi_status", using: :btree
  add_index "tuote", ["yhtio"], name: "toituono_index", using: :btree

  create_table "tuote_muutokset", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",         limit: 5,  default: "", null: false
    t.string   "tuoteno",       limit: 60, default: "", null: false
    t.string   "alkup_tuoteno", limit: 60, default: "", null: false
    t.datetime "muutospvm",                             null: false
    t.string   "kuka",          limit: 50, default: "", null: false
  end

  create_table "tuotepaikat", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",                limit: 5,                           default: "",  null: false
    t.string   "tuoteno",              limit: 60,                          default: "",  null: false
    t.string   "hyllyalue",            limit: 5,                           default: "",  null: false
    t.string   "hyllynro",             limit: 5,                           default: "",  null: false
    t.string   "hyllytaso",            limit: 5,                           default: "",  null: false
    t.string   "hyllyvali",            limit: 5,                           default: "",  null: false
    t.string   "hyllypaikka",          limit: 20,                          default: "",  null: false
    t.decimal  "saldo",                           precision: 12, scale: 2, default: 0.0, null: false
    t.decimal  "saldo_varattu",                   precision: 12, scale: 2, default: 0.0, null: false
    t.datetime "saldoaika",                                                              null: false
    t.decimal  "myytavissa_static",               precision: 12, scale: 2, default: 0.0, null: false
    t.datetime "inventointiaika",                                                        null: false
    t.decimal  "inventointipoikkeama",            precision: 5,  scale: 2, default: 0.0, null: false
    t.decimal  "halytysraja",                     precision: 12, scale: 2, default: 0.0, null: false
    t.decimal  "tilausmaara",                     precision: 12, scale: 2, default: 0.0, null: false
    t.string   "oletus",               limit: 1,                           default: "",  null: false
    t.string   "tyyppi",               limit: 1,                           default: "",  null: false
    t.integer  "prio",                 limit: 4,                           default: 0,   null: false
    t.string   "poistettava",          limit: 1,                           default: "",  null: false
    t.integer  "varasto",              limit: 4
    t.string   "laatija",              limit: 50,                          default: "",  null: false
    t.datetime "luontiaika",                                                             null: false
    t.datetime "muutospvm",                                                              null: false
    t.string   "muuttaja",             limit: 50,                          default: "",  null: false
  end

  add_index "tuotepaikat", ["yhtio", "hyllypaikka"], name: "yhtio_hyllypaikka", using: :btree
  add_index "tuotepaikat", ["yhtio", "saldoaika", "saldo"], name: "saldo_index", using: :btree
  add_index "tuotepaikat", ["yhtio", "tuoteno", "hyllyalue", "hyllynro", "hyllyvali", "hyllytaso"], name: "yhtio_tuoteno_paikka", unique: true, using: :btree
  add_index "tuotepaikat", ["yhtio", "tuoteno"], name: "tuote_index", using: :btree

  create_table "tuoteperhe", primary_key: "tunnus", force: :cascade do |t|
    t.string   "isatuoteno",      limit: 60,                             default: "",  null: false
    t.string   "tuoteno",         limit: 60,                             default: "",  null: false
    t.string   "tyyppi",          limit: 1,                              default: "",  null: false
    t.decimal  "kerroin",                       precision: 15, scale: 9, default: 1.0, null: false
    t.decimal  "hintakerroin",                  precision: 15, scale: 9, default: 1.0, null: false
    t.decimal  "alekerroin",                    precision: 15, scale: 9, default: 1.0, null: false
    t.text     "fakta",           limit: 65535
    t.text     "fakta2",          limit: 65535
    t.string   "piirustusnumero", limit: 60,                             default: ""
    t.string   "osanumero",       limit: 60,                             default: ""
    t.string   "positiokentta",   limit: 60,                             default: ""
    t.string   "omasivu",         limit: 1,                              default: "",  null: false
    t.string   "ei_nayteta",      limit: 1,                              default: "",  null: false
    t.string   "hintatyyppi",     limit: 1,                              default: "",  null: false
    t.string   "ohita_kerays",    limit: 1,                              default: "",  null: false
    t.string   "laatija",         limit: 50,                             default: "",  null: false
    t.datetime "luontiaika",                                                           null: false
    t.datetime "muutospvm",                                                            null: false
    t.string   "muuttaja",        limit: 50,                             default: "",  null: false
    t.string   "yhtio",           limit: 5,                              default: "",  null: false
  end

  add_index "tuoteperhe", ["yhtio", "tyyppi", "isatuoteno"], name: "yhtio_tyyppi_isatuoteno", using: :btree
  add_index "tuoteperhe", ["yhtio", "tyyppi", "tuoteno"], name: "yhtio_tyyppi_tuoteno", using: :btree

  create_table "tuotteen_alv", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",                  limit: 5,                          default: "",  null: false
    t.string   "tuoteno",                limit: 60,                         default: "",  null: false
    t.string   "maa",                    limit: 2,                          default: "",  null: false
    t.decimal  "alv",                               precision: 5, scale: 2, default: 0.0, null: false
    t.string   "tilino",                 limit: 6,                          default: "",  null: false
    t.string   "tilino_eu",              limit: 6,                          default: "",  null: false
    t.string   "tilino_ei_eu",           limit: 6,                          default: "",  null: false
    t.string   "tilino_kaanteinen",      limit: 6,                          default: "",  null: false
    t.string   "tilino_marginaali",      limit: 6,                          default: "",  null: false
    t.string   "tilino_osto_marginaali", limit: 6,                          default: "",  null: false
    t.string   "tilino_triang",          limit: 6,                          default: "",  null: false
    t.integer  "kustp",                  limit: 4,                          default: 0,   null: false
    t.integer  "kohde",                  limit: 4,                          default: 0,   null: false
    t.integer  "projekti",               limit: 4,                          default: 0,   null: false
    t.string   "laatija",                limit: 50,                         default: "",  null: false
    t.datetime "luontiaika",                                                              null: false
    t.string   "muuttaja",               limit: 50,                         default: "",  null: false
    t.datetime "muutospvm",                                                               null: false
  end

  add_index "tuotteen_alv", ["yhtio", "maa", "tuoteno"], name: "yhtio_maa_tuoteno", unique: true, using: :btree

  create_table "tuotteen_avainsanat", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",      limit: 5,     default: "", null: false
    t.string   "tuoteno",    limit: 60,    default: "", null: false
    t.string   "kieli",      limit: 2,     default: "", null: false
    t.string   "laji",       limit: 150,   default: "", null: false
    t.text     "selite",     limit: 65535
    t.text     "selitetark", limit: 65535
    t.string   "status",     limit: 1,     default: "", null: false
    t.string   "nakyvyys",   limit: 1,     default: "", null: false
    t.integer  "jarjestys",  limit: 4,     default: 0,  null: false
    t.string   "laatija",    limit: 50,    default: "", null: false
    t.datetime "luontiaika",                            null: false
    t.datetime "muutospvm",                             null: false
    t.string   "muuttaja",   limit: 50,    default: "", null: false
  end

  add_index "tuotteen_avainsanat", ["yhtio", "kieli", "laji", "selite"], name: "yhtio_kieli_laji_selite", length: {"yhtio"=>nil, "kieli"=>nil, "laji"=>nil, "selite"=>150}, using: :btree
  add_index "tuotteen_avainsanat", ["yhtio", "kieli", "laji", "tuoteno"], name: "yhtio_kieli_laji_tuoteno", using: :btree
  add_index "tuotteen_avainsanat", ["yhtio", "kieli", "tuoteno"], name: "yhtio_kieli_tuoteno", using: :btree
  add_index "tuotteen_avainsanat", ["yhtio", "tuoteno"], name: "yhtio_tuoteno", using: :btree

  create_table "tuotteen_toimittajat", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",                   limit: 5,                            default: "",   null: false
    t.string   "tuoteno",                 limit: 60,                           default: "",   null: false
    t.integer  "liitostunnus",            limit: 4,                            default: 0,    null: false
    t.decimal  "osto_era",                            precision: 12, scale: 2, default: 0.0,  null: false
    t.decimal  "pakkauskoko",                         precision: 12, scale: 2, default: 0.0,  null: false
    t.integer  "toimitusaika",            limit: 4,                            default: 0,    null: false
    t.integer  "tilausvali",              limit: 4,                            default: 0,    null: false
    t.decimal  "tehdas_saldo",                        precision: 12, scale: 2, default: 0.0,  null: false
    t.integer  "tehdas_saldo_toimaika",   limit: 4,                            default: 0,    null: false
    t.datetime "tehdas_saldo_paivitetty",                                                     null: false
    t.decimal  "ostohinta",                           precision: 16, scale: 6, default: 0.0,  null: false
    t.decimal  "alennus",                             precision: 5,  scale: 2, default: 0.0,  null: false
    t.string   "valuutta",                limit: 3,                            default: "",   null: false
    t.decimal  "osto_alv",                            precision: 5,  scale: 2, default: -1.0, null: false
    t.string   "toim_tuoteno",            limit: 30,                           default: "",   null: false
    t.string   "toim_nimitys",            limit: 100,                          default: "",   null: false
    t.string   "toim_yksikko",            limit: 10,                           default: "",   null: false
    t.decimal  "tuotekerroin",                        precision: 9,  scale: 6, default: 0.0,  null: false
    t.string   "viivakoodi",              limit: 150,                          default: "",   null: false
    t.string   "alkuperamaa",             limit: 2,                            default: "",   null: false
    t.integer  "jarjestys",               limit: 4,                            default: 0,    null: false
    t.string   "laatija",                 limit: 50,                           default: "",   null: false
    t.datetime "luontiaika",                                                                  null: false
    t.datetime "muutospvm",                                                                   null: false
    t.string   "muuttaja",                limit: 50,                           default: "",   null: false
  end

  add_index "tuotteen_toimittajat", ["yhtio", "toim_tuoteno"], name: "yhtio_toimtuoteno", using: :btree
  add_index "tuotteen_toimittajat", ["yhtio", "tuoteno", "liitostunnus"], name: "yhtio_tuoteno_liitostunnus", unique: true, using: :btree
  add_index "tuotteen_toimittajat", ["yhtio", "tuoteno"], name: "yhtio_tuoteno", using: :btree
  add_index "tuotteen_toimittajat", ["yhtio", "viivakoodi"], name: "yhtio_viivakoodi", using: :btree

  create_table "tuotteen_toimittajat_pakkauskoot", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",               limit: 5,  default: "", null: false
    t.integer  "toim_tuoteno_tunnus", limit: 4,  default: 0,  null: false
    t.string   "pakkauskoko",         limit: 30, default: "", null: false
    t.string   "yksikko",             limit: 30, default: "", null: false
    t.string   "laatija",             limit: 50, default: "", null: false
    t.datetime "luontiaika"
    t.datetime "muutospvm"
    t.string   "muuttaja",            limit: 50, default: "", null: false
  end

  add_index "tuotteen_toimittajat_pakkauskoot", ["yhtio", "toim_tuoteno_tunnus", "pakkauskoko"], name: "yhtio_toimtuotenotunnus_pakkauskoko", unique: true, using: :btree

  create_table "tuotteen_toimittajat_tuotenumerot", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",               limit: 5,   default: "", null: false
    t.integer  "toim_tuoteno_tunnus", limit: 4,   default: 0,  null: false
    t.string   "tuoteno",             limit: 30,  default: "", null: false
    t.string   "viivakoodi",          limit: 150, default: "", null: false
    t.string   "laatija",             limit: 50,  default: "", null: false
    t.datetime "luontiaika",                                   null: false
    t.datetime "muutospvm",                                    null: false
    t.string   "muuttaja",            limit: 50,  default: "", null: false
  end

  add_index "tuotteen_toimittajat_tuotenumerot", ["yhtio", "toim_tuoteno_tunnus", "tuoteno", "viivakoodi"], name: "tuotteen_toimittajat_tuotenumerot", unique: true, using: :btree
  add_index "tuotteen_toimittajat_tuotenumerot", ["yhtio", "tuoteno"], name: "tuotteen_toimittajat_tuoteno", using: :btree
  add_index "tuotteen_toimittajat_tuotenumerot", ["yhtio", "viivakoodi"], name: "tuotteen_toimittajat_viivakoodi", using: :btree

  create_table "tyomaarayksen_tapahtumat", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",             limit: 5,  default: "", null: false
    t.integer  "tyomaarays_tunnus", limit: 4,  default: 0,  null: false
    t.string   "tyojono_selite",    limit: 60, default: "", null: false
    t.string   "tyostatus_selite",  limit: 60, default: "", null: false
    t.string   "vastuuhenkilo",     limit: 60, default: "", null: false
    t.datetime "luontiaika",                                null: false
    t.string   "laatija",           limit: 50, default: "", null: false
    t.string   "kommentti",         limit: 60, default: "", null: false
  end

  create_table "tyomaarays", primary_key: "otunnus", force: :cascade do |t|
    t.string   "yhtio",                     limit: 5,                              default: "",  null: false
    t.string   "kotipuh",                   limit: 55,                             default: "",  null: false
    t.string   "tyopuh",                    limit: 55,                             default: "",  null: false
    t.string   "myyjaliike",                limit: 55,                             default: "",  null: false
    t.date     "ostopvm",                                                                        null: false
    t.string   "rekno",                     limit: 55,                             default: "",  null: false
    t.string   "mittarilukema",             limit: 55,                             default: "",  null: false
    t.string   "merkki",                    limit: 55,                             default: "",  null: false
    t.string   "mallivari",                 limit: 55,                             default: "",  null: false
    t.text     "valmnro",                   limit: 65535
    t.string   "koodi",                     limit: 60,                             default: "",  null: false
    t.string   "tullikoodi",                limit: 8,                              default: "",  null: false
    t.decimal  "tulliarvo",                               precision: 12, scale: 2, default: 0.0, null: false
    t.string   "maa_lahetys",               limit: 2,                              default: "",  null: false
    t.string   "maa_maara",                 limit: 2,                              default: "",  null: false
    t.string   "maa_alkupera",              limit: 2,                              default: "",  null: false
    t.integer  "kuljetusmuoto",             limit: 1,                              default: 0,   null: false
    t.integer  "kauppatapahtuman_luonne",   limit: 2,                              default: 0,   null: false
    t.decimal  "bruttopaino",                             precision: 8,  scale: 2, default: 0.0, null: false
    t.integer  "sla",                       limit: 4,                              default: 0,   null: false
    t.string   "valmistajan_sopimusnumero", limit: 60,                             default: "",  null: false
    t.date     "tuotu",                                                                          null: false
    t.date     "luvattu",                                                                        null: false
    t.string   "viite",                     limit: 30,                             default: "",  null: false
    t.text     "komm1",                     limit: 65535
    t.text     "komm2",                     limit: 65535
    t.string   "viite2",                    limit: 15,                             default: "",  null: false
    t.integer  "tilno",                     limit: 4,                              default: 0,   null: false
    t.string   "suorittaja",                limit: 50,                             default: "",  null: false
    t.string   "vastuuhenkilo",             limit: 50,                             default: "",  null: false
    t.string   "laatija",                   limit: 50,                             default: "",  null: false
    t.datetime "luontiaika",                                                                     null: false
    t.string   "vikakoodi",                 limit: 50,                             default: "",  null: false
    t.string   "tyoaika",                   limit: 50,                             default: "",  null: false
    t.string   "tyokoodi",                  limit: 50,                             default: "",  null: false
    t.string   "tehdas",                    limit: 80,                             default: "",  null: false
    t.integer  "takuunumero",               limit: 4,                              default: 0,   null: false
    t.string   "jalleenmyyja",              limit: 80,                             default: "",  null: false
    t.string   "tyojono",                   limit: 100,                            default: "",  null: false
    t.string   "tyostatus",                 limit: 100,                            default: "",  null: false
    t.string   "prioriteetti",              limit: 150,                            default: "",  null: false
    t.string   "hyvaksy",                   limit: 55,                             default: "",  null: false
  end

  create_table "uutinen_asiakassegmentti", primary_key: "tunnus", force: :cascade do |t|
    t.string  "yhtio",           limit: 5, default: "", null: false
    t.integer "uutistunnus",     limit: 4, default: 0,  null: false
    t.integer "segmenttitunnus", limit: 4, default: 0,  null: false
  end

  create_table "vaihtoehtoiset_verkkolaskutunnukset", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",        limit: 5,  default: "", null: false
    t.integer  "toimi_tunnus", limit: 4,  default: 0,  null: false
    t.string   "kohde_sarake", limit: 50, default: "", null: false
    t.string   "arvo",         limit: 25, default: "", null: false
    t.string   "laatija",      limit: 50, default: "", null: false
    t.datetime "luontiaika",                           null: false
    t.datetime "muutospvm",                            null: false
    t.string   "muuttaja",     limit: 50, default: "", null: false
  end

  create_table "vak", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",                                                            limit: 5,     default: "", null: false
    t.string   "yk_nro",                                                           limit: 5,     default: "", null: false
    t.text     "nimi_ja_kuvaus",                                                   limit: 65535
    t.text     "name_and_description",                                             limit: 65535
    t.string   "luokka",                                                           limit: 5,     default: "", null: false
    t.string   "luokituskoodi",                                                    limit: 15,    default: "", null: false
    t.string   "pakkausryhma",                                                     limit: 150,   default: "", null: false
    t.text     "lipukkeet",                                                        limit: 65535
    t.text     "erityismaaraykset",                                                limit: 65535
    t.string   "rajoitetut_maarat_ja_poikkeusmaarat_1",                            limit: 25,    default: "", null: false
    t.string   "rajoitetut_maarat_ja_poikkeusmaarat_2",                            limit: 25,    default: "", null: false
    t.text     "pakkaukset_pakkaustavat",                                          limit: 65535
    t.text     "pakkaukset_erityispakkaus_maara",                                  limit: 65535
    t.text     "pakkaukset_yhteenpakkaamismaara",                                  limit: 65535
    t.text     "un_sailiot_ja_irtotavarakontit_soveltamisehdot",                   limit: 65535
    t.text     "un_sailiot_ja_irtotavarakontit_erityismaaraykset",                 limit: 65535
    t.text     "vak_adr_sailiot_sailiokoodit",                                     limit: 65535
    t.text     "vak_adr_sailiot_erityismaaraykset",                                limit: 65535
    t.string   "ajoneuvo_sailiokuljetuksissa",                                     limit: 15,    default: "", null: false
    t.text     "kuljetus_kategoria",                                               limit: 65535
    t.text     "kuljetukseen_liittyvat_erityismaaraykset_kollit",                  limit: 65535
    t.text     "kuljetukseen_liittyvat_erityismaaraykset_irtotavara",              limit: 65535
    t.text     "kuljetukseen_liittyvat_erityismaaraykset_kuorm_purk_ja_kasittely", limit: 65535
    t.string   "kuljetukseen_liittyvat_erityismaaraykset_kuljetustapahtuma",       limit: 55,    default: "", null: false
    t.string   "vaaran_tunnusnro",                                                 limit: 5,     default: "", null: false
    t.string   "laatija",                                                          limit: 50,    default: "", null: false
    t.datetime "luontiaika",                                                                                  null: false
    t.datetime "muutospvm",                                                                                   null: false
    t.string   "muuttaja",                                                         limit: 50,    default: "", null: false
  end

  create_table "vak_imdg", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",                                                            limit: 5,     default: "", null: false
    t.string   "yk_nro",                                                           limit: 5,     default: "", null: false
    t.text     "nimi_ja_kuvaus",                                                   limit: 65535
    t.text     "name_and_description",                                             limit: 65535
    t.string   "luokka",                                                           limit: 5,     default: "", null: false
    t.string   "luokituskoodi",                                                    limit: 15,    default: "", null: false
    t.string   "pakkausryhma",                                                     limit: 150,   default: "", null: false
    t.text     "lipukkeet",                                                        limit: 65535
    t.text     "erityismaaraykset",                                                limit: 65535
    t.string   "rajoitetut_maarat_ja_poikkeusmaarat_1",                            limit: 25,    default: "", null: false
    t.string   "rajoitetut_maarat_ja_poikkeusmaarat_2",                            limit: 25,    default: "", null: false
    t.text     "pakkaukset_pakkaustavat",                                          limit: 65535
    t.text     "pakkaukset_erityispakkaus_maara",                                  limit: 65535
    t.text     "pakkaukset_yhteenpakkaamismaara",                                  limit: 65535
    t.text     "un_sailiot_ja_irtotavarakontit_soveltamisehdot",                   limit: 65535
    t.text     "un_sailiot_ja_irtotavarakontit_erityismaaraykset",                 limit: 65535
    t.text     "vak_imdg_sailiot_sailiokoodit",                                    limit: 65535
    t.text     "vak_imdg_sailiot_erityismaaraykset",                               limit: 65535
    t.string   "ajoneuvo_sailiokuljetuksissa",                                     limit: 15,    default: "", null: false
    t.text     "kuljetus_kategoria",                                               limit: 65535
    t.text     "kuljetukseen_liittyvat_erityismaaraykset_kollit",                  limit: 65535
    t.text     "kuljetukseen_liittyvat_erityismaaraykset_irtotavara",              limit: 65535
    t.text     "kuljetukseen_liittyvat_erityismaaraykset_kuorm_purk_ja_kasittely", limit: 65535
    t.string   "kuljetukseen_liittyvat_erityismaaraykset_kuljetustapahtuma",       limit: 55,    default: "", null: false
    t.string   "vaaran_tunnusnro",                                                 limit: 5,     default: "", null: false
    t.string   "laatija",                                                          limit: 50,    default: "", null: false
    t.datetime "luontiaika",                                                                                  null: false
    t.datetime "muutospvm",                                                                                   null: false
    t.string   "muuttaja",                                                         limit: 50,    default: "", null: false
  end

  create_table "valuu", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",            limit: 5,                           default: "",  null: false
    t.string   "nimi",             limit: 3,                           default: "",  null: false
    t.decimal  "jarjestys",                   precision: 2,            default: 0,   null: false
    t.decimal  "kurssi",                      precision: 15, scale: 9, default: 0.0, null: false
    t.decimal  "intrastat_kurssi",            precision: 15, scale: 9, default: 0.0, null: false
    t.decimal  "hinnastokurssi",              precision: 15, scale: 9, default: 0.0, null: false
    t.string   "laatija",          limit: 50,                          default: "",  null: false
    t.datetime "luontiaika",                                                         null: false
    t.datetime "muutospvm",                                                          null: false
    t.string   "muuttaja",         limit: 50,                          default: "",  null: false
  end

  add_index "valuu", ["yhtio", "nimi"], name: "yhtio_nimi", unique: true, using: :btree

  create_table "valuu_historia", primary_key: "tunnus", force: :cascade do |t|
    t.string  "kotivaluutta", limit: 3,                          default: "",  null: false
    t.string  "valuutta",     limit: 3,                          default: "",  null: false
    t.date    "kurssipvm",                                                     null: false
    t.decimal "kurssi",                 precision: 15, scale: 9, default: 0.0, null: false
  end

  add_index "valuu_historia", ["kotivaluutta", "valuutta", "kurssipvm"], name: "kotivaluutta_valkoodi_kurssipvm", unique: true, using: :btree

  create_table "varaston_hyllypaikat", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",          limit: 5,                            default: "",  null: false
    t.string   "hyllyalue",      limit: 5,                            default: "",  null: false
    t.string   "hyllynro",       limit: 5,                            default: "",  null: false
    t.string   "hyllyvali",      limit: 5,                            default: "",  null: false
    t.string   "hyllytaso",      limit: 5,                            default: "",  null: false
    t.integer  "varasto",        limit: 4,                            default: 0,   null: false
    t.string   "reservipaikka",  limit: 1,                            default: "E", null: false
    t.integer  "indeksi",        limit: 4,                            default: 0,   null: false
    t.decimal  "korkeus",                    precision: 10, scale: 4, default: 0.0, null: false
    t.decimal  "leveys",                     precision: 10, scale: 4, default: 0.0, null: false
    t.decimal  "syvyys",                     precision: 10, scale: 4, default: 0.0, null: false
    t.decimal  "minimi_korkeus",             precision: 10, scale: 4, default: 0.0, null: false
    t.decimal  "minimi_leveys",              precision: 10, scale: 4, default: 0.0, null: false
    t.decimal  "minimi_syvyys",              precision: 10, scale: 4, default: 0.0, null: false
    t.decimal  "maksimitaakka",              precision: 10, scale: 4, default: 0.0, null: false
    t.string   "varmistuskoodi", limit: 150,                          default: "",  null: false
    t.integer  "kiertovaatimus", limit: 4,                            default: 0,   null: false
    t.integer  "keraysvyohyke",  limit: 4,                            default: 0,   null: false
    t.string   "laatija",        limit: 50,                           default: "",  null: false
    t.datetime "luontiaika",                                                        null: false
    t.datetime "muutospvm",                                                         null: false
    t.string   "muuttaja",       limit: 50,                           default: "",  null: false
  end

  add_index "varaston_hyllypaikat", ["yhtio", "hyllyalue", "hyllynro", "hyllyvali", "hyllytaso"], name: "yhtio_paikka", unique: true, using: :btree
  add_index "varaston_hyllypaikat", ["yhtio", "varasto", "korkeus", "leveys", "syvyys", "maksimitaakka"], name: "yhtio_varasto_mitat", using: :btree

  create_table "varaston_tulostimet", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",          limit: 5,   default: "", null: false
    t.integer  "varasto",        limit: 8,   default: 0,  null: false
    t.string   "nimi",           limit: 15,  default: "", null: false
    t.string   "pakkaamo",       limit: 150, default: "", null: false
    t.integer  "prioriteetti",   limit: 4,   default: 0,  null: false
    t.string   "alkuhyllyalue",  limit: 5,   default: "", null: false
    t.string   "alkuhyllynro",   limit: 5,   default: "", null: false
    t.string   "loppuhyllyalue", limit: 5,   default: "", null: false
    t.string   "loppuhyllynro",  limit: 5,   default: "", null: false
    t.string   "printteri0",     limit: 20,  default: "", null: false
    t.string   "printteri1",     limit: 20,  default: "", null: false
    t.string   "printteri2",     limit: 20,  default: "", null: false
    t.string   "printteri3",     limit: 20,  default: "", null: false
    t.string   "printteri4",     limit: 20,  default: "", null: false
    t.string   "printteri6",     limit: 20,  default: "", null: false
    t.string   "printteri7",     limit: 20,  default: "", null: false
    t.string   "laatija",        limit: 50,  default: "", null: false
    t.datetime "luontiaika",                              null: false
    t.datetime "muutospvm",                               null: false
    t.string   "muuttaja",       limit: 50,  default: "", null: false
  end

  create_table "varastopaikat", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",                            limit: 5,                            default: "",  null: false
    t.string   "alkuhyllyalue",                    limit: 5,                            default: "",  null: false
    t.string   "alkuhyllynro",                     limit: 5,                            default: "",  null: false
    t.string   "loppuhyllyalue",                   limit: 5,                            default: "",  null: false
    t.string   "loppuhyllynro",                    limit: 5,                            default: "",  null: false
    t.string   "printteri0",                       limit: 20,                           default: "",  null: false
    t.string   "printteri1",                       limit: 20,                           default: "",  null: false
    t.string   "printteri2",                       limit: 20,                           default: "",  null: false
    t.string   "printteri3",                       limit: 20,                           default: "",  null: false
    t.string   "printteri4",                       limit: 20,                           default: "",  null: false
    t.string   "printteri5",                       limit: 20,                           default: "",  null: false
    t.string   "printteri6",                       limit: 20,                           default: "",  null: false
    t.string   "printteri7",                       limit: 20,                           default: "",  null: false
    t.string   "printteri9",                       limit: 20,                           default: "",  null: false
    t.string   "printteri10",                      limit: 20,                           default: "",  null: false
    t.string   "nimitys",                          limit: 100,                          default: "",  null: false
    t.string   "tyyppi",                           limit: 1,                            default: "",  null: false
    t.integer  "nouto",                            limit: 4,                            default: 0,   null: false
    t.integer  "toimipaikka",                      limit: 4,                            default: 0,   null: false
    t.string   "nimi",                             limit: 60,                           default: "",  null: false
    t.string   "nimitark",                         limit: 55,                           default: "",  null: false
    t.string   "osoite",                           limit: 55,                           default: "",  null: false
    t.string   "postino",                          limit: 15,                           default: "",  null: false
    t.string   "postitp",                          limit: 35,                           default: "",  null: false
    t.string   "maa",                              limit: 35,                           default: "",  null: false
    t.string   "maa_maara",                        limit: 2,                            default: "",  null: false
    t.string   "sisamaan_kuljetus",                limit: 30,                           default: "",  null: false
    t.string   "sisamaan_kuljetus_kansallisuus",   limit: 2,                            default: "",  null: false
    t.integer  "sisamaan_kuljetusmuoto",           limit: 4,                            default: 0,   null: false
    t.integer  "kontti",                           limit: 4,                            default: 0,   null: false
    t.string   "aktiivinen_kuljetus",              limit: 30,                           default: "",  null: false
    t.string   "aktiivinen_kuljetus_kansallisuus", limit: 2,                            default: "",  null: false
    t.decimal  "erikoistoimitus_alarajasumma",                 precision: 12, scale: 2, default: 0.0, null: false
    t.string   "erikoistoimitus_toimitustapa",     limit: 50,                           default: "",  null: false
    t.integer  "kauppatapahtuman_luonne",          limit: 4,                            default: 0,   null: false
    t.integer  "kuljetusmuoto",                    limit: 4,                            default: 0,   null: false
    t.string   "poistumistoimipaikka_koodi",       limit: 8,                            default: "",  null: false
    t.string   "ulkoinen_jarjestelma",             limit: 1,                            default: "",  null: false
    t.integer  "pikahakuarvo",                     limit: 4,                            default: 0
    t.string   "sallitut_maat",                    limit: 50,                           default: "",  null: false
    t.integer  "isa_varasto",                      limit: 4,                            default: 0,   null: false
    t.integer  "prioriteetti",                     limit: 4,                            default: 0,   null: false
    t.string   "laatija",                          limit: 50,                           default: "",  null: false
    t.datetime "luontiaika",                                                                          null: false
    t.datetime "muutospvm",                                                                           null: false
    t.string   "muuttaja",                         limit: 50,                           default: "",  null: false
  end

  add_index "varastopaikat", ["yhtio", "alkuhyllyalue", "alkuhyllynro"], name: "yhtio_alku", using: :btree
  add_index "varastopaikat", ["yhtio", "loppuhyllyalue", "loppuhyllynro"], name: "yhtio_loppu", using: :btree
  add_index "varastopaikat", ["yhtio", "maa"], name: "yhtio_maa", using: :btree

  create_table "vastaavat", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",          limit: 5,  default: "", null: false
    t.integer  "jarjestys",      limit: 8,  default: 0,  null: false
    t.string   "tuoteno",        limit: 60, default: "", null: false
    t.integer  "id",             limit: 8,  default: 0,  null: false
    t.string   "vaihtoehtoinen", limit: 1,  default: "", null: false
    t.string   "laatija",        limit: 50, default: "", null: false
    t.datetime "luontiaika",                             null: false
    t.datetime "muutospvm",                              null: false
    t.string   "muuttaja",       limit: 50, default: "", null: false
  end

  add_index "vastaavat", ["yhtio", "id"], name: "yhtio_id", using: :btree
  add_index "vastaavat", ["yhtio", "tuoteno"], name: "yhtio_tuoteno", using: :btree

  create_table "yhteyshenkilo", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",                  limit: 5,     default: "", null: false
    t.string   "tyyppi",                 limit: 1,     default: "", null: false
    t.integer  "liitostunnus",           limit: 4,     default: 0,  null: false
    t.string   "nimi",                   limit: 50,    default: "", null: false
    t.string   "titteli",                limit: 50,    default: "", null: false
    t.string   "rooli",                  limit: 100,   default: "", null: false
    t.string   "suoramarkkinointi",      limit: 100,   default: "", null: false
    t.string   "email",                  limit: 50,    default: "", null: false
    t.string   "puh",                    limit: 50,    default: "", null: false
    t.string   "gsm",                    limit: 50,    default: "", null: false
    t.string   "fax",                    limit: 50,    default: "", null: false
    t.string   "www",                    limit: 50,    default: "", null: false
    t.string   "nimitarkenne",           limit: 100
    t.string   "osoite",                 limit: 100
    t.string   "postino",                limit: 5
    t.string   "postitp",                limit: 50
    t.string   "maa",                    limit: 50
    t.text     "fakta",                  limit: 65535
    t.string   "ulkoinen_asiakasnumero", limit: 50,    default: "", null: false
    t.string   "tilausyhteyshenkilo",    limit: 1,     default: "", null: false
    t.string   "oletusyhteyshenkilo",    limit: 1,     default: "", null: false
    t.string   "aktivointikuittaus",     limit: 1,     default: "", null: false
    t.string   "verkkokauppa_salasana",  limit: 255
    t.string   "verkkokauppa_nakyvyys",  limit: 255
    t.string   "laatija",                limit: 50,    default: "", null: false
    t.datetime "luontiaika",                                        null: false
    t.datetime "muutospvm",                                         null: false
    t.string   "muuttaja",               limit: 50,    default: "", null: false
  end

  add_index "yhteyshenkilo", ["yhtio", "tyyppi", "liitostunnus", "rooli"], name: "yhtio_tyyppi_liitostunnus_rooli", using: :btree

  create_table "yhtio", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",                             limit: 5,                           default: "",  null: false
    t.integer  "jarjestys",                         limit: 4,                           default: 0,   null: false
    t.string   "konserni",                          limit: 5,                           default: "",  null: false
    t.string   "ytunnus",                           limit: 30,                          default: "",  null: false
    t.string   "ovttunnus",                         limit: 25,                          default: "",  null: false
    t.string   "kotipaikka",                        limit: 25,                          default: "",  null: false
    t.string   "nimi",                              limit: 60,                          default: "",  null: false
    t.string   "osoite",                            limit: 30,                          default: "",  null: false
    t.string   "postino",                           limit: 15,                          default: "",  null: false
    t.string   "postitp",                           limit: 30,                          default: "",  null: false
    t.string   "maa",                               limit: 2,                           default: "",  null: false
    t.string   "laskutus_nimi",                     limit: 60,                          default: "",  null: false
    t.string   "laskutus_osoite",                   limit: 30,                          default: "",  null: false
    t.string   "laskutus_postino",                  limit: 15,                          default: "",  null: false
    t.string   "laskutus_postitp",                  limit: 30,                          default: "",  null: false
    t.string   "laskutus_maa",                      limit: 2,                           default: "",  null: false
    t.string   "kieli",                             limit: 2,                           default: "",  null: false
    t.string   "valkoodi",                          limit: 3,                           default: "",  null: false
    t.string   "fax",                               limit: 25,                          default: "",  null: false
    t.string   "puhelin",                           limit: 25,                          default: "",  null: false
    t.string   "email",                             limit: 60,                          default: "",  null: false
    t.string   "www",                               limit: 100,                         default: "",  null: false
    t.integer  "ean",                               limit: 4,                           default: 0,   null: false
    t.string   "pankkinimi1",                       limit: 80,                          default: "",  null: false
    t.string   "pankkitili1",                       limit: 80,                          default: "",  null: false
    t.string   "pankkiiban1",                       limit: 60,                          default: "",  null: false
    t.string   "pankkiswift1",                      limit: 60,                          default: "",  null: false
    t.string   "pankkinimi2",                       limit: 80,                          default: "",  null: false
    t.string   "pankkitili2",                       limit: 80,                          default: "",  null: false
    t.string   "pankkiiban2",                       limit: 60,                          default: "",  null: false
    t.string   "pankkiswift2",                      limit: 60,                          default: "",  null: false
    t.string   "pankkinimi3",                       limit: 80,                          default: "",  null: false
    t.string   "pankkitili3",                       limit: 80,                          default: "",  null: false
    t.string   "pankkiiban3",                       limit: 60,                          default: "",  null: false
    t.string   "pankkiswift3",                      limit: 60,                          default: "",  null: false
    t.string   "kassa",                             limit: 6,                           default: "",  null: false
    t.string   "pankkikortti",                      limit: 6,                           default: "",  null: false
    t.string   "luottokortti",                      limit: 6,                           default: "",  null: false
    t.string   "kassaerotus",                       limit: 6,                           default: "",  null: false
    t.string   "kateistilitys",                     limit: 6,                           default: "",  null: false
    t.string   "myynti",                            limit: 6,                           default: "",  null: false
    t.string   "myynti_eu",                         limit: 6,                           default: "",  null: false
    t.string   "myynti_ei_eu",                      limit: 6,                           default: "",  null: false
    t.string   "myynti_kaanteinen",                 limit: 6,                           default: "",  null: false
    t.string   "tilino_triang",                     limit: 6,                           default: "",  null: false
    t.string   "myynti_marginaali",                 limit: 6,                           default: "",  null: false
    t.string   "osto_marginaali",                   limit: 6,                           default: "",  null: false
    t.string   "osto_rahti",                        limit: 6,                           default: "",  null: false
    t.string   "osto_kulu",                         limit: 6,                           default: "",  null: false
    t.string   "osto_rivi_kulu",                    limit: 6,                           default: "",  null: false
    t.string   "myyntisaamiset",                    limit: 6,                           default: "",  null: false
    t.string   "luottotappiot",                     limit: 6,                           default: "",  null: false
    t.string   "factoringsaamiset",                 limit: 6,                           default: "",  null: false
    t.string   "konsernimyyntisaamiset",            limit: 6,                           default: "",  null: false
    t.string   "ostovelat",                         limit: 6,                           default: "",  null: false
    t.string   "konserniostovelat",                 limit: 6,                           default: "",  null: false
    t.string   "valuuttaero",                       limit: 6,                           default: "",  null: false
    t.string   "myynninvaluuttaero",                limit: 6,                           default: "",  null: false
    t.string   "kassaale",                          limit: 6,                           default: "",  null: false
    t.string   "myynninkassaale",                   limit: 6,                           default: "",  null: false
    t.string   "muutkulut",                         limit: 6,                           default: "",  null: false
    t.string   "pyoristys",                         limit: 6,                           default: "",  null: false
    t.string   "varasto",                           limit: 6,                           default: "",  null: false
    t.string   "raaka_ainevarasto",                 limit: 6,                           default: "",  null: false
    t.string   "varastonmuutos",                    limit: 6,                           default: "",  null: false
    t.string   "raaka_ainevarastonmuutos",          limit: 6,                           default: "",  null: false
    t.string   "varastonmuutos_valmistuksesta",     limit: 6,                           default: "",  null: false
    t.string   "varastonmuutos_epakurantti",        limit: 6,                           default: "",  null: false
    t.string   "varastonmuutos_inventointi",        limit: 6,                           default: "",  null: false
    t.string   "varastonmuutos_rahti",              limit: 6,                           default: "",  null: false
    t.string   "matkalla_olevat",                   limit: 6,                           default: "",  null: false
    t.string   "alv",                               limit: 6,                           default: "",  null: false
    t.string   "siirtosaamiset",                    limit: 6,                           default: "",  null: false
    t.string   "siirtovelka",                       limit: 6,                           default: "",  null: false
    t.string   "konsernisaamiset",                  limit: 6,                           default: "",  null: false
    t.string   "konsernivelat",                     limit: 6,                           default: "",  null: false
    t.string   "selvittelytili",                    limit: 6,                           default: "",  null: false
    t.string   "ostolasku_kotimaa_kulu",            limit: 6,                           default: "",  null: false
    t.string   "ostolasku_kotimaa_rahti",           limit: 6,                           default: "",  null: false
    t.string   "ostolasku_kotimaa_vaihto_omaisuus", limit: 6,                           default: "",  null: false
    t.string   "ostolasku_kotimaa_raaka_aine",      limit: 6,                           default: "",  null: false
    t.string   "ostolasku_eu_kulu",                 limit: 6,                           default: "",  null: false
    t.string   "ostolasku_eu_rahti",                limit: 6,                           default: "",  null: false
    t.string   "ostolasku_eu_vaihto_omaisuus",      limit: 6,                           default: "",  null: false
    t.string   "ostolasku_eu_raaka_aine",           limit: 6,                           default: "",  null: false
    t.string   "ostolasku_ei_eu_kulu",              limit: 6,                           default: "",  null: false
    t.string   "ostolasku_ei_eu_rahti",             limit: 6,                           default: "",  null: false
    t.string   "ostolasku_ei_eu_vaihto_omaisuus",   limit: 6,                           default: "",  null: false
    t.string   "ostolasku_ei_eu_raaka_aine",        limit: 6,                           default: "",  null: false
    t.integer  "myynti_kustp",                      limit: 4,                           default: 0,   null: false
    t.integer  "myynti_kohde",                      limit: 4,                           default: 0,   null: false
    t.integer  "myynti_projekti",                   limit: 4,                           default: 0,   null: false
    t.integer  "tilikauden_tulos",                  limit: 4,                           default: 0,   null: false
    t.date     "tilikausi_alku",                                                                      null: false
    t.date     "tilikausi_loppu",                                                                     null: false
    t.date     "ostoreskontrakausi_alku",                                                             null: false
    t.date     "ostoreskontrakausi_loppu",                                                            null: false
    t.date     "myyntireskontrakausi_alku",                                                           null: false
    t.date     "myyntireskontrakausi_loppu",                                                          null: false
    t.string   "tullin_asiaknro",                   limit: 6,                           default: "",  null: false
    t.string   "tullin_lupanro",                    limit: 10,                          default: "",  null: false
    t.integer  "tullikamari",                       limit: 4,                           default: 0,   null: false
    t.string   "tullipaate",                        limit: 3,                           default: "",  null: false
    t.decimal  "tulli_vahennettava_era",                        precision: 8, scale: 2, default: 0.0, null: false
    t.decimal  "tulli_lisattava_era",                           precision: 8, scale: 2, default: 0.0, null: false
    t.string   "kotitullauslupa",                   limit: 15,                          default: "",  null: false
    t.integer  "tilastotullikamari",                limit: 4,                           default: 0,   null: false
    t.string   "intrastat_sarjanro",                limit: 3,                           default: "",  null: false
    t.string   "int_koodi",                         limit: 5,                           default: "",  null: false
    t.decimal  "viivastyskorko",                                precision: 5, scale: 2, default: 0.0, null: false
    t.integer  "karhuerapvm",                       limit: 4,                           default: 0,   null: false
    t.decimal  "kuluprosentti",                                 precision: 8, scale: 3, default: 0.0, null: false
    t.string   "laatija",                           limit: 50,                          default: "",  null: false
    t.datetime "luontiaika",                                                                          null: false
    t.datetime "muutospvm",                                                                           null: false
    t.string   "muuttaja",                          limit: 50,                          default: "",  null: false
  end

  add_index "yhtio", ["yhtio"], name: "yhtio_index", using: :btree

  create_table "yhtion_parametrit", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",                                            limit: 5,                              default: "",    null: false
    t.string   "admin_email",                                      limit: 100,                            default: "",    null: false
    t.string   "alert_email",                                      limit: 100,                            default: "",    null: false
    t.string   "talhal_email",                                     limit: 100,                            default: "",    null: false
    t.string   "sahkopostilasku_cc_email",                         limit: 100,                            default: "",    null: false
    t.string   "maksukehotus_cc_email",                            limit: 100,                            default: "",    null: false
    t.text     "varauskalenteri_email",                            limit: 65535
    t.string   "tuotekopio_email",                                 limit: 100,                            default: "",    null: false
    t.string   "jt_email",                                         limit: 100,                            default: "",    null: false
    t.string   "edi_email",                                        limit: 100,                            default: "",    null: false
    t.string   "extranet_kerayspoikkeama_email",                   limit: 100,                            default: "",    null: false
    t.string   "siirtolista_email",                                limit: 100,                            default: "",    null: false
    t.string   "changelog_email",                                  limit: 100,                            default: "",    null: false
    t.string   "hyvaksyttavia_tilauksia_email",                    limit: 100,                            default: "",    null: false
    t.string   "ostotilaus_email",                                 limit: 100,                            default: "",    null: false
    t.string   "hyvaksyttavat_extranet_email",                     limit: 255,                            default: "",    null: false
    t.string   "alert_varasto_kayttajat",                          limit: 100,                            default: "",    null: false
    t.string   "verkkolasku_lah",                                  limit: 10,                             default: "",    null: false
    t.string   "finvoice_versio",                                  limit: 1,                              default: "",    null: false
    t.string   "verkkolasku_vienti",                               limit: 1,                              default: "",    null: false
    t.string   "finvoice_senderpartyid",                           limit: 100,                            default: "",    null: false
    t.string   "finvoice_senderintermediator",                     limit: 100,                            default: "",    null: false
    t.string   "verkkotunnus_vas",                                 limit: 100,                            default: "",    null: false
    t.string   "verkkotunnus_lah",                                 limit: 100,                            default: "",    null: false
    t.string   "verkkosala_vas",                                   limit: 100,                            default: "",    null: false
    t.string   "verkkosala_lah",                                   limit: 100,                            default: "",    null: false
    t.string   "apix_tunnus",                                      limit: 100,                            default: "",    null: false
    t.string   "apix_avain",                                       limit: 100,                            default: "",    null: false
    t.string   "apix_edi_tunnus",                                  limit: 100,                            default: "",    null: false
    t.string   "apix_edi_avain",                                   limit: 100,                            default: "",    null: false
    t.string   "maventa_api_avain",                                limit: 100,                            default: "",    null: false
    t.string   "maventa_yrityksen_uuid",                           limit: 100,                            default: "",    null: false
    t.string   "maventa_ohjelmisto_api_avain",                     limit: 100,                            default: "",    null: false
    t.datetime "maventa_aikaleima",                                                                                       null: false
    t.integer  "lasku_tulostin",                                   limit: 8,                              default: 0,     null: false
    t.string   "pankkitiedostot",                                  limit: 1,                              default: "",    null: false
    t.string   "tiliotteen_selvittelyt",                           limit: 1,                              default: "",    null: false
    t.string   "kuvapankki_polku",                                 limit: 255,                            default: "",    null: false
    t.string   "skannatut_laskut_polku",                           limit: 255,                            default: "",    null: false
    t.string   "postittaja_email",                                 limit: 200,                            default: "",    null: false
    t.string   "kayttoliittyma",                                   limit: 1,                              default: "",    null: false
    t.text     "css",                                              limit: 65535
    t.text     "css_classic",                                      limit: 65535
    t.text     "css_extranet",                                     limit: 65535
    t.text     "css_verkkokauppa",                                 limit: 65535
    t.text     "web_seuranta",                                     limit: 65535
    t.string   "lahetteen_tulostustapa",                           limit: 1,                              default: "",    null: false
    t.string   "kulujen_laskeminen_hintoihin",                     limit: 1,                              default: "",    null: false
    t.string   "myyntitilin_tulostustapa",                         limit: 1,                              default: "",    null: false
    t.string   "valmistuksen_tulostustapa",                        limit: 1,                              default: "",    null: false
    t.string   "siirtolistan_tulostustapa",                        limit: 1,                              default: "",    null: false
    t.string   "lahetteen_jarjestys",                              limit: 1,                              default: "",    null: false
    t.string   "lahetteen_jarjestys_suunta",                       limit: 4,                              default: "",    null: false
    t.string   "lahetteen_palvelutjatuottet",                      limit: 1,                              default: "",    null: false
    t.string   "laskun_jarjestys",                                 limit: 1,                              default: "",    null: false
    t.string   "laskun_jarjestys_suunta",                          limit: 4,                              default: "",    null: false
    t.string   "laskun_palvelutjatuottet",                         limit: 1,                              default: "",    null: false
    t.string   "tilauksen_jarjestys",                              limit: 1,                              default: "",    null: false
    t.string   "tilauksen_jarjestys_suunta",                       limit: 4,                              default: "",    null: false
    t.string   "kerayslistan_jarjestys",                           limit: 1,                              default: "",    null: false
    t.string   "kerayslistan_jarjestys_suunta",                    limit: 4,                              default: "",    null: false
    t.string   "kerayslistan_palvelutjatuottet",                   limit: 1,                              default: "",    null: false
    t.string   "valmistus_kerayslistan_jarjestys",                 limit: 1,                              default: "",    null: false
    t.string   "valmistus_kerayslistan_jarjestys_suunta",          limit: 4,                              default: "",    null: false
    t.string   "valmistus_kerayslistan_palvelutjatuottet",         limit: 1,                              default: "",    null: false
    t.string   "valmistuksessa_kaytetaan_tilakoodeja",             limit: 1,                              default: "",    null: false
    t.string   "ostotilauksen_jarjestys",                          limit: 1,                              default: "",    null: false
    t.string   "ostotilauksen_jarjestys_suunta",                   limit: 4,                              default: "",    null: false
    t.string   "tarjouksen_jarjestys",                             limit: 1,                              default: "",    null: false
    t.string   "tarjouksen_jarjestys_suunta",                      limit: 4,                              default: "",    null: false
    t.string   "tarjouksen_palvelutjatuottet",                     limit: 1,                              default: "",    null: false
    t.string   "tyomaarayksen_jarjestys",                          limit: 1,                              default: "",    null: false
    t.string   "tyomaarayksen_jarjestys_suunta",                   limit: 4,                              default: "",    null: false
    t.string   "tyomaarayksen_palvelutjatuottet",                  limit: 1,                              default: "",    null: false
    t.string   "tuotteiden_jarjestys_raportoinnissa",              limit: 1,                              default: "",    null: false
    t.string   "pakkaamolokerot",                                  limit: 1,                              default: "",    null: false
    t.string   "konsernivarasto",                                  limit: 1,                              default: "",    null: false
    t.string   "lahete_allekirjoitus",                             limit: 1,                              default: "",    null: false
    t.string   "lomakkeiden_allekirjoitus",                        limit: 1,                              default: "",    null: false
    t.string   "lahete_tyyppi_tulostus",                           limit: 1,                              default: "",    null: false
    t.integer  "laskutyyppi",                                      limit: 4,                              default: 0,     null: false
    t.string   "laskun_monistus_kommenttikentta",                  limit: 1,                              default: "",    null: false
    t.string   "viivakoodi_laskulle",                              limit: 1,                              default: "",    null: false
    t.string   "koontilaskut_yhdistetaan",                         limit: 1,                              default: "",    null: false
    t.decimal  "koontilaskut_alarajasumma",                                      precision: 12, scale: 2, default: 0.0,   null: false
    t.string   "koontilahete_kollitiedot",                         limit: 1,                              default: "",    null: false
    t.string   "tilausvahvistustyyppi",                            limit: 150,                            default: "",    null: false
    t.integer  "tilausvahvistus_tilausnumero",                     limit: 1,                              default: 0,     null: false
    t.string   "tilausvahvistus_tyyppi_tulostus",                  limit: 1,                              default: "",    null: false
    t.integer  "tilausvahvistus_lahetys",                          limit: 4,                              default: 0,     null: false
    t.string   "tilausvahvistus_tallenna",                         limit: 1,                              default: "",    null: false
    t.string   "tilausvahvistus_sisaisista",                       limit: 1,                              default: "",    null: false
    t.string   "naytayhteensamaarat",                              limit: 1,                              default: "",    null: false
    t.integer  "tarjoustyyppi",                                    limit: 4,                              default: 0,     null: false
    t.string   "siirtolistatyyppi",                                limit: 1,                              default: "",    null: false
    t.string   "varastosiirto_tilausvahvistus",                    limit: 1,                              default: "",    null: false
    t.string   "varastosiirto_kohdepaikka",                        limit: 1,                              default: "",    null: false
    t.string   "ostotilaustyyppi",                                 limit: 1,                              default: "",    null: false
    t.string   "ostotilaukseen_toimittajan_toimaika",              limit: 1,                              default: "",    null: false
    t.string   "ostotilaus_saman_tuotteen_lisays",                 limit: 1,                              default: "",    null: false
    t.string   "ostotilauksen_tuloste",                            limit: 1,                              default: "",    null: false
    t.string   "ostolaskujen_paivays",                             limit: 1,                              default: "",    null: false
    t.string   "ostolaskujen_oletusvaluutta",                      limit: 1,                              default: "",    null: false
    t.string   "ostolaskujen_oletusiban",                          limit: 1,                              default: "",    null: false
    t.integer  "ostolaskujen_kurssipaiva",                         limit: 4,                              default: 0,     null: false
    t.integer  "myyntilaskujen_kurssipaiva",                       limit: 1,                              default: 0,     null: false
    t.string   "laskutus_tulevaisuuteen",                          limit: 1,                              default: "",    null: false
    t.string   "kateiskuitin_paivays",                             limit: 1,                              default: "",    null: false
    t.string   "ostolaskun_kulutilit",                             limit: 1,                              default: "",    null: false
    t.string   "ostolaskun_kulutilit_kayttaytyminen",              limit: 1,                              default: "",    null: false
    t.string   "tarkenteiden_tarkistus_hyvaksynnassa",             limit: 1,                              default: "",    null: false
    t.string   "tyomaaraystyyppi",                                 limit: 1,                              default: "",    null: false
    t.string   "tyomaarays_tulostus_lisarivit",                    limit: 1,                              default: "",    null: false
    t.string   "tyomaarays_asennuskalenteri_muistutus",            limit: 1,                              default: "",    null: false
    t.string   "viivakoodi_purkulistaan",                          limit: 1,                              default: "",    null: false
    t.string   "purkulistan_asettelu",                             limit: 1,                              default: "",    null: false
    t.string   "kerayslista_kerayspaikka",                         limit: 1,                              default: "",    null: false
    t.integer  "laskutuskielto",                                   limit: 4,                              default: 0,     null: false
    t.string   "saldovirhe_esto_laskutus",                         limit: 1,                              default: "",    null: false
    t.string   "kehahinvirhe_esto_laskutus",                       limit: 1,                              default: "",    null: false
    t.string   "rahti_hinnoittelu",                                limit: 1,                              default: "",    null: false
    t.string   "rahti_tuotenumero",                                limit: 60,                             default: "",    null: false
    t.string   "jalkivaatimus_tuotenumero",                        limit: 60,                             default: "",    null: false
    t.string   "kasittelykulu_tuotenumero",                        limit: 60,                             default: "",    null: false
    t.string   "maksuehto_tuotenumero",                            limit: 60,                             default: "",    null: false
    t.string   "ennakkomaksu_tuotenumero",                         limit: 60,                             default: "",    null: false
    t.string   "alennus_tuotenumero",                              limit: 60,                             default: "",    null: false
    t.string   "laskutuslisa_tuotenumero",                         limit: 60,                             default: "",    null: false
    t.string   "erilliskasiteltava_tuotenumero",                   limit: 60,                             default: "",    null: false
    t.string   "lisakulu_tuotenumero",                             limit: 60,                             default: "",    null: false
    t.decimal  "laskutuslisa",                                                   precision: 5,  scale: 2, default: 0.0,   null: false
    t.string   "laskutuslisa_tyyppi",                              limit: 1,                              default: "",    null: false
    t.string   "kuljetusvakuutus_tuotenumero",                     limit: 60,                             default: "",    null: false
    t.decimal  "kuljetusvakuutus",                                               precision: 5,  scale: 2, default: 0.0,   null: false
    t.string   "kuljetusvakuutus_tyyppi",                          limit: 1,                              default: "",    null: false
    t.string   "kuljetusvakuutus_koonti",                          limit: 1,                              default: "",    null: false
    t.string   "tuotteen_oletuspaikka",                            limit: 250,                            default: "",    null: false
    t.string   "alv_kasittely",                                    limit: 1,                              default: "",    null: false
    t.string   "alv_kasittely_hintamuunnos",                       limit: 1,                              default: "",    null: false
    t.string   "alv_velvollinen",                                  limit: 1,                              default: "",    null: false
    t.string   "asiakashinta_netto",                               limit: 2,                              default: "",    null: false
    t.string   "puute_jt_oletus",                                  limit: 1,                              default: "",    null: false
    t.string   "puute_jt_kerataanko",                              limit: 1,                              default: "",    null: false
    t.string   "myynti_jt_huom",                                   limit: 1,                              default: "",    null: false
    t.string   "kerataanko_jos_vain_puute_jt",                     limit: 1,                              default: "",    null: false
    t.string   "jt_automatiikka",                                  limit: 1,                              default: "",    null: false
    t.string   "jt_automatiikka_mitatoi_tilaus",                   limit: 1,                              default: "",    null: false
    t.string   "saapumisen_jt_kasittely",                          limit: 1,                              default: "",    null: false
    t.string   "jt_toimitus_varastorajaus",                        limit: 1,                              default: "",    null: false
    t.string   "jt_rahti",                                         limit: 1,                              default: "",    null: false
    t.string   "jt_rivien_kasittely",                              limit: 1,                              default: "",    null: false
    t.string   "jt_toimitusaika_email_vahvistus",                  limit: 1,                              default: "",    null: false
    t.string   "vahvistusviesti_asiakkaalle",                      limit: 1,                              default: "",    null: false
    t.string   "jt_manual",                                        limit: 1,                              default: "",    null: false
    t.string   "jt_asiakkaan_tilausnumero",                        limit: 1,                              default: "",    null: false
    t.string   "jt_siirtolistojen_yhdistaminen",                   limit: 1,                              default: "",    null: false
    t.string   "jt_email_tilauksessa",                             limit: 1,                              default: "",    null: false
    t.string   "kerayslistojen_yhdistaminen",                      limit: 1,                              default: "",    null: false
    t.string   "karayksesta_rahtikirjasyottoon",                   limit: 1,                              default: "",    null: false
    t.string   "rahtikirjojen_esisyotto",                          limit: 1,                              default: "",    null: false
    t.string   "saldottomat_rahtikirjansyottoon",                  limit: 1,                              default: "",    null: false
    t.string   "rahtikirjan_kollit_ja_lajit",                      limit: 1,                              default: "",    null: false
    t.string   "laskunsummapyoristys",                             limit: 1,                              default: "",    null: false
    t.integer  "hintapyoristys",                                   limit: 4,                              default: 2,     null: false
    t.string   "hintapyoristys_loppunollat",                       limit: 1,                              default: "",    null: false
    t.string   "viitteen_kasinsyotto",                             limit: 1,                              default: "",    null: false
    t.decimal  "suoratoim_ulkomaan_alarajasumma",                                precision: 12, scale: 2, default: 0.0,   null: false
    t.decimal  "erikoisvarastomyynti_alarajasumma",                              precision: 12, scale: 2, default: 0.0,   null: false
    t.decimal  "erikoisvarastomyynti_alarajasumma_rivi",                         precision: 12, scale: 2, default: 0.0,   null: false
    t.decimal  "rahtivapaa_alarajasumma",                                        precision: 12, scale: 2, default: 0.0,   null: false
    t.decimal  "tehdas_saldo_alaraja",                                           precision: 12, scale: 2, default: 0.0,   null: false
    t.string   "logo",                                             limit: 100,                            default: "",    null: false
    t.string   "lasku_logo",                                       limit: 100,                            default: "",    null: false
    t.string   "lasku_logo_positio",                               limit: 7,                              default: "",    null: false
    t.integer  "lasku_logo_koko",                                  limit: 4,                              default: 0,     null: false
    t.string   "naytetaan_katteet_tilauksella",                    limit: 1,                              default: "",    null: false
    t.string   "tuotekommentti_tilausriville",                     limit: 1,                              default: "",    null: false
    t.string   "tilauksen_yhteyshenkilot",                         limit: 1,                              default: "",    null: false
    t.string   "tarjouksen_voi_versioida",                         limit: 1,                              default: "",    null: false
    t.string   "nimityksen_muutos_tilauksella",                    limit: 1,                              default: "",    null: false
    t.string   "automaattinen_tuotehaku",                          limit: 1,                              default: "",    null: false
    t.string   "tuotekysely",                                      limit: 1,                              default: "",    null: false
    t.string   "jyvita_alennus",                                   limit: 1,                              default: "",    null: false
    t.string   "salli_jyvitys_myynnissa",                          limit: 1,                              default: "",    null: false
    t.string   "salli_jyvitys_tarjouksella",                       limit: 1,                              default: "",    null: false
    t.string   "naytetaan_tilausvahvistusnappi",                   limit: 1,                              default: "",    null: false
    t.string   "rivinumero_syotto",                                limit: 1,                              default: "",    null: false
    t.string   "tee_osto_myyntitilaukselta",                       limit: 1,                              default: "",    null: false
    t.string   "tee_automaattinen_osto_myyntitilaukselta",         limit: 1,                              default: "",    null: false
    t.string   "tee_automaattinen_siirto_myyntitilaukselta",       limit: 1,                              default: "",    null: false
    t.string   "tee_valmistus_myyntitilaukselta",                  limit: 1,                              default: "",    null: false
    t.string   "tee_siirtolista_myyntitilaukselta",                limit: 1,                              default: "",    null: false
    t.string   "kirjanpidollinen_varastosiirto_myyntitilaukselta", limit: 1,                              default: "",    null: false
    t.string   "automaattinen_jt_toimitus",                        limit: 1,                              default: "",    null: false
    t.string   "automaattinen_jt_toimitus_valmistus",              limit: 1,                              default: "",    null: false
    t.string   "automaattinen_jt_toimitus_siirtolista",            limit: 1,                              default: "",    null: false
    t.string   "siirtolistat_vastaanotetaan_per_lahto",            limit: 1,                              default: "",    null: false
    t.string   "dynaaminen_kassamyynti",                           limit: 1,                              default: "",    null: false
    t.string   "maksupaate_kassamyynti",                           limit: 1,                              default: "",    null: false
    t.string   "pikatilaus_focus",                                 limit: 1,                              default: "",    null: false
    t.string   "kerayspoikkeama_kasittely",                        limit: 1,                              default: "",    null: false
    t.integer  "kerayspoikkeamaviestin_lahetys",                   limit: 4,                              default: 0,     null: false
    t.string   "kerayspoikkeama_email",                            limit: 1,                              default: "",    null: false
    t.string   "keraysvahvistus_lahetys",                          limit: 1,                              default: "",    null: false
    t.string   "kerays_riveittain",                                limit: 255,                            default: "",    null: false
    t.string   "oletus_toimitusehto",                              limit: 30,                             default: "",    null: false
    t.string   "oletus_toimitusehto2",                             limit: 30,                             default: "",    null: false
    t.string   "sad_lomake_tyyppi",                                limit: 1,                              default: "",    null: false
    t.integer  "tarjouksen_voimaika",                              limit: 4,                              default: 14,    null: false
    t.string   "tarjouksen_tuotepaikat",                           limit: 1,                              default: "",    null: false
    t.string   "tarjouksen_alv_kasittely",                         limit: 1,                              default: "",    null: false
    t.string   "splittauskielto",                                  limit: 1,                              default: "",    null: false
    t.string   "rekursiiviset_reseptit",                           limit: 1,                              default: "",    null: false
    t.string   "rekursiiviset_tuoteperheet",                       limit: 1,                              default: "",    null: false
    t.string   "valmistusten_yhdistaminen",                        limit: 1,                              default: "",    null: false
    t.integer  "rahtikirjan_kopiomaara",                           limit: 4,                              default: 0,     null: false
    t.string   "saldotarkistus_tulostusjonossa",                   limit: 2,                              default: "",    null: false
    t.string   "kerataanko_saldottomat",                           limit: 1,                              default: "",    null: false
    t.string   "kerataanko_valmistukset",                          limit: 1,                              default: "",    null: false
    t.string   "kerataanko_tyomaaraykset",                         limit: 1,                              default: "",    null: false
    t.string   "saldo_kasittely",                                  limit: 1,                              default: "",    null: false
    t.string   "ytunnus_tarkistukset",                             limit: 1,                              default: "",    null: false
    t.string   "vienti_erittelyn_tulostus",                        limit: 1,                              default: "",    null: false
    t.string   "vientierittelyn_painot",                           limit: 1,                              default: "",    null: false
    t.string   "vientikiellon_ohitus",                             limit: 1,                              default: "",    null: false
    t.integer  "oletus_lahetekpl",                                 limit: 4,                              default: 0,     null: false
    t.integer  "oletus_lahetekpl_siirtolista",                     limit: 4,                              default: 1,     null: false
    t.integer  "oletus_laskukpl_toimitatilaus",                    limit: 4,                              default: 1,     null: false
    t.integer  "oletus_oslappkpl",                                 limit: 4,                              default: 0,     null: false
    t.integer  "oletus_rahtikirja_lahetekpl",                      limit: 4,                              default: 0,     null: false
    t.integer  "oletus_rahtikirja_oslappkpl",                      limit: 4,                              default: 0,     null: false
    t.string   "oslapp_rakir_logo",                                limit: 1,                              default: "",    null: false
    t.string   "osoitelappu_lisatiedot",                           limit: 1,                              default: "",    null: false
    t.string   "rahti_ja_kasittelykulut_kasin",                    limit: 1,                              default: "",    null: false
    t.text     "synkronoi",                                        limit: 65535
    t.string   "myyntitilaus_osatoimitus",                         limit: 1,                              default: "",    null: false
    t.string   "myyntitilaus_ytunnus_syotto",                      limit: 1,                              default: "",    null: false
    t.string   "myyntitilaus_asiakasmemo",                         limit: 1,                              default: "",    null: false
    t.string   "myyntitilaus_saatavat",                            limit: 1,                              default: "",    null: false
    t.string   "myyntitilaus_tarjoukseksi",                        limit: 1,                              default: "",    null: false
    t.string   "myyntitilauksen_liitteet",                         limit: 1,                              default: "",    null: false
    t.string   "myyntitilauksen_toimipaikka",                      limit: 1,                              default: "",    null: false
    t.string   "varastopaikan_lippu",                              limit: 1,                              default: "",    null: false
    t.string   "varastopaikkojen_maarittely",                      limit: 1,                              default: "",    null: false
    t.string   "varastontunniste",                                 limit: 1,                              default: "",    null: false
    t.string   "pakollinen_varasto",                               limit: 1,                              default: "",    null: false
    t.string   "ulkoinen_jarjestelma",                             limit: 1,                              default: "",    null: false
    t.string   "ulkoinen_jarjestelma_lukko",                       limit: 1,                              default: ""
    t.string   "suuntalavat",                                      limit: 1,                              default: "",    null: false
    t.string   "kerayserat",                                       limit: 1,                              default: "",    null: false
    t.string   "varaako_jt_saldoa",                                limit: 1,                              default: "",    null: false
    t.string   "korvaavan_hinta_ylaraja",                          limit: 3,                              default: "",    null: false
    t.string   "korvaavat_hyvaksynta",                             limit: 1,                              default: "",    null: false
    t.string   "korvaavuusketjun_jarjestys",                       limit: 1,                              default: "",    null: false
    t.string   "korvaavuusketjun_puutekasittely",                  limit: 1,                              default: "",    null: false
    t.string   "vastaavuusketjun_jarjestys",                       limit: 1,                              default: "",    null: false
    t.string   "monikayttajakalenteri",                            limit: 1,                              default: "",    null: false
    t.string   "automaattinen_asiakasnumerointi",                  limit: 1,                              default: "",    null: false
    t.integer  "asiakasnumeroinnin_aloituskohta",                  limit: 4,                              default: 0,     null: false
    t.string   "asiakkaan_tarkenne",                               limit: 1,                              default: "",    null: false
    t.string   "haejaselaa_konsernisaldot",                        limit: 1,                              default: "",    null: false
    t.string   "viikkosuunnitelma",                                limit: 1,                              default: "",    null: false
    t.string   "kalenterimerkinnat",                               limit: 1,                              default: "",    null: false
    t.string   "kalenteri_aikavali",                               limit: 2,                              default: "",    null: false
    t.string   "tuntikirjausten_erittely",                         limit: 1,                              default: "",    null: false
    t.string   "variaatiomyynti",                                  limit: 1,                              default: "",    null: false
    t.string   "nayta_variaatiot",                                 limit: 1,                              default: "",    null: false
    t.string   "myyntiera_pyoristys",                              limit: 1,                              default: "",    null: false
    t.string   "minimimaara_pyoristys",                            limit: 1,                              default: ""
    t.string   "ostoera_pyoristys",                                limit: 1,                              default: "",    null: false
    t.string   "reklamaation_kasittely",                           limit: 1,                              default: "",    null: false
    t.string   "reklamaation_kasittely_tuoteperhe",                limit: 1,                              default: "",    null: false
    t.string   "reklamaation_hinnoittelu",                         limit: 1,                              default: "",    null: false
    t.integer  "reklamaation_vastaanottovarasto",                  limit: 4,                              default: 0,     null: false
    t.string   "myytitilauksen_kululaskut",                        limit: 1,                              default: "",    null: false
    t.string   "huomautetaanko_poistuvasta",                       limit: 1,                              default: "",    null: false
    t.string   "palvelutuotteiden_kehahinnat",                     limit: 1,                              default: "",    null: false
    t.string   "kehahinarvio_ennen_ensituloa",                     limit: 1,                              default: "",    null: false
    t.string   "tyomaaraystiedot_tarjouksella",                    limit: 1,                              default: "",    null: false
    t.string   "rinnakkaisostaja_myynnissa",                       limit: 1,                              default: "",    null: false
    t.string   "tilausrivien_toimitettuaika",                      limit: 1,                              default: "",    null: false
    t.string   "tilausrivin_esisyotto",                            limit: 1,                              default: "",    null: false
    t.string   "tilausvahvistus_jttoimituksista",                  limit: 1,                              default: "",    null: false
    t.string   "jt_rivien_saapumisajan_nayttaminen",               limit: 1,                              default: "",    null: false
    t.string   "naytetaanko_osaston_ja_tryn_selite",               limit: 1,                              default: "",    null: false
    t.string   "naytetaanko_ale_peruste_tilausrivilla",            limit: 1,                              default: "",    null: false
    t.string   "tilauksen_myyntieratiedot",                        limit: 1,                              default: "",    null: false
    t.string   "tilaukselle_mittatiedot",                          limit: 1,                              default: "",    null: false
    t.string   "livetuotehaku_tilauksella",                        limit: 1,                              default: "",    null: false
    t.integer  "livetuotehaku_minimi",                             limit: 1,                              default: 3,     null: false
    t.string   "livetuotehaku_hakutapa",                           limit: 1,                              default: "",    null: false
    t.string   "livetuotehaku_hakutapa_extranet",                  limit: 1,                              default: "",    null: false
    t.string   "livetuotehaku_poistetut",                          limit: 1,                              default: "",    null: false
    t.string   "poistetut_lisays",                                 limit: 1,                              default: "",    null: false
    t.string   "iltasiivo_mitatoi_ext_tilauksia",                  limit: 3,                              default: "",    null: false
    t.string   "extranet_tilaus_varaa_saldoa",                     limit: 3,                              default: "",    null: false
    t.string   "extranet_nayta_saldo",                             limit: 1,                              default: "",    null: false
    t.string   "extranet_nayta_kuvaus",                            limit: 1,                              default: "",    null: false
    t.string   "extranet_poikkeava_toimitusosoite",                limit: 1,                              default: "",    null: false
    t.string   "extranet_keraysprioriteetti",                      limit: 1,                              default: "",    null: false
    t.string   "extranet_private_label",                           limit: 1,                              default: "",    null: false
    t.string   "ext_tilauksen_hyvaksyja_myyjaksi",                 limit: 1,                              default: "",    null: false
    t.string   "tuoteperhe_suoratoimitus",                         limit: 1,                              default: "",    null: false
    t.string   "tuoteperheinfo_lahetteella",                       limit: 1,                              default: "",    null: false
    t.string   "kirjanpidon_tarkenteet",                           limit: 1,                              default: "",    null: false
    t.string   "tuoteperhe_kasittely",                             limit: 1,                              default: "",    null: false
    t.string   "hyvaksy_tarjous_tilaustyyppi",                     limit: 1,                              default: "",    null: false
    t.string   "vaihda_asiakas_hintapaiv",                         limit: 1,                              default: "",    null: false
    t.string   "keraysaikarajaus",                                 limit: 2,                              default: "",    null: false
    t.string   "liitetiedostojen_nimeaminen",                      limit: 1,                              default: "",    null: false
    t.string   "varastoonvientipaiva",                             limit: 1,                              default: "",    null: false
    t.string   "varaston_splittaus",                               limit: 1,                              default: "",    null: false
    t.string   "oletusvarasto_tilaukselle",                        limit: 1,                              default: "",    null: false
    t.integer  "ostoreskontra_kassaalekasittely",                  limit: 4,                              default: 0,     null: false
    t.string   "myyntilaskun_erapvmlaskenta",                      limit: 1,                              default: "",    null: false
    t.string   "vak_kasittely",                                    limit: 1,                              default: "",    null: false
    t.string   "vak_erittely",                                     limit: 1,                              default: "",    null: false
    t.string   "intrastat_kaytossa",                               limit: 1,                              default: "",    null: false
    t.string   "intrastat_pvm",                                    limit: 1,                              default: "",    null: false
    t.string   "myynti_asiakhin_tallenna",                         limit: 1,                              default: "",    null: false
    t.integer  "myynnin_alekentat",                                limit: 4,                              default: 1,     null: false
    t.string   "myynnin_alekentat_muokkaus",                       limit: 50,                             default: "1",   null: false
    t.string   "oston_alekentat",                                  limit: 1,                              default: "1",   null: false
    t.string   "tilausrivi_omalle_tilaukselle",                    limit: 1,                              default: "",    null: false
    t.string   "haejaselaa_saapumispvm",                           limit: 1,                              default: "",    null: false
    t.string   "ennakkotilausten_toimitus",                        limit: 1,                              default: "",    null: false
    t.string   "jalkilaskenta_kuluperuste",                        limit: 2,                              default: "",    null: false
    t.string   "teeostotilaus_valmistuksen_tulosjonosta",          limit: 1,                              default: "",    null: false
    t.string   "tarkista_eankoodi",                                limit: 1,                              default: "",    null: false
    t.string   "raaka_aineet_valmistusmyynti",                     limit: 1,                              default: "",    null: false
    t.string   "raaka_aine_tiliointi",                             limit: 1,                              default: "",    null: false
    t.string   "tulosta_valmistus_tulosteet",                      limit: 1,                              default: "",    null: false
    t.string   "valmistuksien_kasittely",                          limit: 1,                              default: "",    null: false
    t.string   "kehahinta_valmistuksella",                         limit: 1,                              default: "",    null: false
    t.string   "saldo_varastossa_valmistuksella",                  limit: 1,                              default: "",    null: false
    t.string   "varastonarvon_jako_usealle_valmisteelle",          limit: 1,                              default: "",    null: false
    t.string   "maksukehotus_kentat",                              limit: 1,                              default: "",    null: false
    t.string   "maksukehotuksen_osoitetiedot",                     limit: 1,                              default: "",    null: false
    t.float    "viitemaksujen_kohdistus_sallittu_heitto",          limit: 24,                             default: 0.0,   null: false
    t.string   "luottorajan_ylitys",                               limit: 1,                              default: "",    null: false
    t.string   "luottorajan_tarkistus",                            limit: 1,                              default: "",    null: false
    t.integer  "erapaivan_ylityksen_raja",                         limit: 4,                              default: 15,    null: false
    t.string   "erapaivan_ylityksen_toimenpide",                   limit: 1,                              default: "",    null: false
    t.string   "vastaanottoraportti",                              limit: 1,                              default: "",    null: false
    t.string   "tositteen_tilioinnit",                             limit: 1,                              default: "",    null: false
    t.string   "ei_alennuksia_lapsituotteille",                    limit: 1,                              default: "",    null: false
    t.string   "epakurantoinnin_myyntihintaleikkuri",              limit: 1,                              default: "",    null: false
    t.string   "ennakkolaskun_tyyppi",                             limit: 1,                              default: "",    null: false
    t.string   "maksusopimus_toimitus",                            limit: 1,                              default: "",    null: false
    t.string   "ennakkolasku_myyntitilaukselta",                   limit: 1,                              default: "",    null: false
    t.string   "matkalaskun_tarkastus",                            limit: 1,                              default: "",    null: false
    t.string   "seuraava_tuotenumero",                             limit: 1,                              default: "",    null: false
    t.string   "myyntitilausrivi_rekisterinumero",                 limit: 1,                              default: "",    null: false
    t.string   "ostotilauksen_kasittely",                          limit: 150,                            default: "",    null: false
    t.string   "vastaavat_tuotteet_esitysmuoto",                   limit: 1,                              default: "",    null: false
    t.string   "laite_huolto",                                     limit: 1,                              default: "",    null: false
    t.string   "paivita_oletuspaikka",                             limit: 1,                              default: "",    null: false
    t.string   "myyntihinta_paivitys_saapuminen",                  limit: 1,                              default: "",    null: false
    t.string   "myyntihinnan_muutoksien_logitus",                  limit: 1,                              default: "",    null: false
    t.string   "suoratoim_lisamyynti_osto",                        limit: 1,                              default: "",    null: false
    t.string   "editilaus_suoratoimitus",                          limit: 1,                              default: "",    null: false
    t.string   "toimipaikkakasittely",                             limit: 1,                              default: "",    null: false
    t.string   "tarkenteiden_prioriteetti",                        limit: 1,                              default: "",    null: false
    t.integer  "suoratoimitusvarasto",                             limit: 4,                              default: 0,     null: false
    t.integer  "takuuvarasto",                                     limit: 4,                              default: 0,     null: false
    t.string   "nouto_suoraan_laskutukseen",                       limit: 1,                              default: "",    null: false
    t.string   "reklamaatiot_lasku",                               limit: 1,                              default: "",    null: false
    t.string   "yhdistetaan_identtiset_laskulla",                  limit: 1,                              default: "",    null: false
    t.string   "sallitaanko_kateismyynti_laskulle",                limit: 1,                              default: "",    null: false
    t.boolean  "lapsituotteen_poiston_esto",                                                              default: false, null: false
    t.string   "pura_osaluettelot",                                limit: 1,                              default: "",    null: false
    t.string   "laiterekisteri_kaytossa",                          limit: 1,                              default: "",    null: false
    t.string   "inventointi_yhteenveto",                           limit: 1,                              default: "",    null: false
    t.string   "laaja_inventointilista",                           limit: 1,                              default: "",    null: false
    t.string   "inventointi_siirron_yhteydessa",                   limit: 1,                              default: "",    null: false
    t.integer  "muokkaatilaus_pv_rajaus",                          limit: 4,                              default: 0,     null: false
    t.string   "tilausrivin_korvamerkinta",                        limit: 1,                              default: "",    null: false
    t.integer  "tilausrivin_kateraja",                             limit: 4,                              default: 0,     null: false
    t.string   "viitemaksujen_oikaisut",                           limit: 1,                              default: "",    null: false
    t.string   "pdf_ruudulle_kieli",                               limit: 1,                              default: "",    null: false
    t.integer  "laskun_kanavointitiedon_syotto",                   limit: 1,                              default: 0,     null: false
    t.string   "laatija",                                          limit: 50,                             default: "",    null: false
    t.datetime "luontiaika",                                                                                              null: false
    t.datetime "muutospvm",                                                                                               null: false
    t.string   "muuttaja",                                         limit: 50,                             default: "",    null: false
  end

  add_index "yhtion_parametrit", ["yhtio"], name: "yhtio_index", using: :btree

  create_table "yhtion_toimipaikat", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",                         limit: 5,   default: "", null: false
    t.string   "ovtlisa",                       limit: 16,  default: "", null: false
    t.string   "vat_numero",                    limit: 50,  default: "", null: false
    t.string   "kotipaikka",                    limit: 25,  default: "", null: false
    t.string   "nimi",                          limit: 60,  default: "", null: false
    t.string   "osoite",                        limit: 30,  default: "", null: false
    t.string   "postino",                       limit: 15,  default: "", null: false
    t.string   "postitp",                       limit: 30,  default: "", null: false
    t.string   "maa",                           limit: 2,   default: "", null: false
    t.string   "fax",                           limit: 25,  default: "", null: false
    t.string   "puhelin",                       limit: 25,  default: "", null: false
    t.string   "email",                         limit: 60,  default: "", null: false
    t.string   "postittaja_email",              limit: 200, default: "", null: false
    t.string   "www",                           limit: 100, default: "", null: false
    t.string   "lasku_logo",                    limit: 100, default: "", null: false
    t.string   "tilino",                        limit: 6,   default: "", null: false
    t.string   "tilino_eu",                     limit: 6,   default: "", null: false
    t.string   "tilino_ei_eu",                  limit: 6,   default: "", null: false
    t.string   "tilino_kaanteinen",             limit: 6,   default: "", null: false
    t.string   "tilino_marginaali",             limit: 6,   default: "", null: false
    t.string   "tilino_osto_marginaali",        limit: 6,   default: "", null: false
    t.string   "tilino_triang",                 limit: 6,   default: "", null: false
    t.string   "toim_alv",                      limit: 6,   default: "", null: false
    t.string   "toim_automaattinen_jtraportti", limit: 3,   default: "", null: false
    t.string   "ostotilauksen_kasittely",       limit: 150, default: "", null: false
    t.string   "sahkoinen_automaattituloutus",  limit: 1,   default: "", null: false
    t.string   "liiketunnus",                   limit: 100, default: "", null: false
    t.integer  "kustp",                         limit: 4,   default: 0,  null: false
    t.integer  "kohde",                         limit: 4,   default: 0,  null: false
    t.integer  "projekti",                      limit: 4,   default: 0,  null: false
    t.integer  "pikahakuarvo",                  limit: 4,   default: 0
    t.string   "laatija",                       limit: 50,  default: "", null: false
    t.datetime "luontiaika",                                             null: false
    t.datetime "muutospvm",                                              null: false
    t.string   "muuttaja",                      limit: 50,  default: "", null: false
  end

  add_index "yhtion_toimipaikat", ["yhtio"], name: "yhtio_index", using: :btree

  create_table "yhtion_toimipaikat_parametrit", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",       limit: 5,     default: "", null: false
    t.integer  "toimipaikka", limit: 4,     default: 0,  null: false
    t.string   "parametri",   limit: 150,   default: "", null: false
    t.text     "arvo",        limit: 65535
    t.string   "laatija",     limit: 50,    default: "", null: false
    t.datetime "luontiaika",                             null: false
    t.datetime "muutospvm",                              null: false
    t.string   "muuttaja",    limit: 50,    default: "", null: false
  end

  add_index "yhtion_toimipaikat_parametrit", ["yhtio"], name: "yhtio_index", using: :btree

  create_table "yriti", primary_key: "tunnus", force: :cascade do |t|
    t.string   "yhtio",                 limit: 5,                           default: "",  null: false
    t.string   "kaytossa",              limit: 1,                           default: "",  null: false
    t.string   "nimi",                  limit: 40,                          default: "",  null: false
    t.string   "tilino",                limit: 35,                          default: "",  null: false
    t.string   "iban",                  limit: 34,                          default: "",  null: false
    t.string   "bic",                   limit: 11,                          default: "",  null: false
    t.string   "valkoodi",              limit: 3,                           default: "",  null: false
    t.string   "factoring",             limit: 1,                           default: "",  null: false
    t.string   "asiakastunnus",         limit: 15,                          default: "",  null: false
    t.decimal  "maksulimitti",                     precision: 12, scale: 2, default: 0.0, null: false
    t.string   "tilinylitys",           limit: 1,                           default: "",  null: false
    t.string   "hyvak",                 limit: 50,                          default: "",  null: false
    t.string   "oletus_kulutili",       limit: 6,                           default: "",  null: false
    t.integer  "oletus_kustp",          limit: 4,                           default: 0,   null: false
    t.integer  "oletus_kohde",          limit: 4,                           default: 0,   null: false
    t.integer  "oletus_projekti",       limit: 4,                           default: 0,   null: false
    t.string   "oletus_rahatili",       limit: 6,                           default: "",  null: false
    t.string   "oletus_selvittelytili", limit: 6,                           default: "",  null: false
    t.string   "laatija",               limit: 50,                          default: "",  null: false
    t.datetime "luontiaika",                                                              null: false
    t.datetime "muutospvm",                                                               null: false
    t.string   "muuttaja",              limit: 50,                          default: "",  null: false
  end

  add_index "yriti", ["yhtio", "iban"], name: "index_yriti_on_yhtio_and_iban", using: :btree
  add_index "yriti", ["yhtio", "tilino"], name: "yhtio_tilino", unique: true, using: :btree

end
