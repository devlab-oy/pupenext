require File.expand_path('test/permission_helper')
include PermissionHelper

class SepaDirectDebit < ActiveRecord::Migration
  def up
    add_column :maksuehto, :directdebit_id, :integer, limit: 4, after: :factoring_id

    create_table :directdebit, primary_key: "tunnus", force: :cascade do |t|
      t.string  :yhtio, limit: 5, default: "", null: false
      t.string  :nimitys, limit: 50, default: "", null: false
      t.string  :palvelutunnus, limit: 35, default: "", null: false
      t.string  :muuttaja, limit: 50, default: "", null: false
      t.string  :laatija, limit: 50, default: "", null: false
      t.datetime :luontiaika, null: false, default: 0
      t.datetime :muutospvm, null: false, default: 0
    end

    add_column :lasku, :directdebitsiirtonumero, :integer, default: 0, null: false, after: :factoringsiirtonumero

    execute "alter table directdebit modify column tunnus int auto_increment after muutospvm;"

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
  end

  def down
    remove_column :maksuehto, :directdebit_id
    remove_column :lasku, :directdebitsiirtonumero
    drop_table :directdebit
  end
end
