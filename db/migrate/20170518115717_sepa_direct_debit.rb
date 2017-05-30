require File.expand_path('test/permission_helper')
include PermissionHelper

class SepaDirectDebit < ActiveRecord::Migration
  def up

    create_table :directdebit, primary_key: "tunnus", force: :cascade do |t|
      t.string   :yhtio, limit: 5, default: "", null: false
      t.string   :rahalaitos, limit: 20, default: "", null: false
      t.string   :nimitys, limit: 50, default: "", null: false
      t.string   :palvelutunnus, limit: 35, default: "", null: false
      t.string   :suoraveloitusmandaatti, limit: 50, default: "", null: false
      t.string   :muuttaja, limit: 50, default: "", null: false
      t.string   :laatija, limit: 50, default: "", null: false
      t.datetime :luontiaika, null: false, default: 0
      t.datetime :muutospvm, null: false, default: 0
    end

    create_table :directdebit_asiakas, primary_key: "tunnus", force: :cascade do |t|
      t.string   :yhtio, limit: 5, default: "", null: false
      t.integer  :liitostunnus, limit: 4, default: 0,  null: false
      t.integer  :directdebit_id, limit: 4
      t.string   :valtuutus_id, limit: 35, default: "", null: false
      t.date     :valtuutus_pvm, null: false, default: 0
      t.string   :maksajan_iban, limit: 35, default: "",  null: false
      t.string   :maksajan_swift, limit: 11, default: "",  null: false
      t.string   :muuttaja, limit: 50, default: "", null: false
      t.string   :laatija, limit: 50, default: "", null: false
      t.datetime :luontiaika, null: false, default: 0
      t.datetime :muutospvm, null: false, default: 0
    end

    execute "alter table directdebit modify column tunnus int auto_increment after muutospvm;"
    execute "alter table directdebit_asiakas modify column tunnus int auto_increment after muutospvm;"

    add_column :lasku, :directdebitsiirtonumero, :integer, default: 0, null: false, after: :factoringsiirtonumero
    add_column :maksuehto, :directdebit_id, :integer, limit: 4, after: :factoring_id

    PermissionHelper.add_item(
      program: 'Ylläpito',
      name: 'Direct Debit-sopimukset',
      uri: 'yllapito.php',
      suburi: 'directdebit',
      hidden: '',
    )

    PermissionHelper.add_item(
      program: 'Ylläpito',
      name: 'Nordea Direct Debit',
      uri: 'directdebit.php',
      suburi: '',
      hidden: '',
    )

    PermissionHelper.add_item(
      program: 'Asiakkaat',
      name: 'Direct Debit-tiedot',
      uri: 'yllapito.php',
      suburi: 'directdebit_asiakas',
      hidden: 'o',
    )
  end

  def down
    remove_column :maksuehto, :directdebit_id
    remove_column :lasku, :directdebitsiirtonumero
    drop_table :directdebit
    drop_table :directdebit_asiakas
  end
end
