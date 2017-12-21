class CreateToimitustavanAvainsanatTable < ActiveRecord::Migration
  def up
    create_table :toimitustavan_avainsanat do |t|
      t.string  :yhtio, limit: 5, default: "", null: false
      t.integer  :liitostunnus, limit: 11, default: 0, null: false
      t.string :kieli, limit: 2, default: 0, null: false
      t.string  :laji, limit: 150, default: "", null: false
      t.text  :selite, limit: 255, default: null, null: true
      t.text  :selitetark, limit: 255, default: null, null: true
      t.string  :laatija, limit: 50, default: "", null: false
      t.datetime :luontiaika, null: false, default: 0
      t.string  :muuttaja, limit: 50, default: "", null: false
      t.datetime :muutospvm, null: false, default: 0
    end

    add_index :toimitustavan_avainsanat, [:yhtio, :liitostunnus, :kieli, :laji], name: "yhtio_liitostunnus_kieli_laji", unique: false
    add_index :toimitustavan_avainsanat, [:yhtio, :kieli, :laji, :liitostunnus], name: "yhtio__kieli_laji_liitostunnus", unique: false

    PermissionHelper.add_item(
      program: 'Yllapito',
      name: 'Toimitustavan avainsanat',
      uri: 'yllapito.php',
      suburi: 'toimitustavan_avainsanat'
    )
  end

  def down
    drop_table :changelog

    PermissionHelper.remove_all(
      uri: 'yllapito.php',
      suburi: 'toimitustavan_avainsanat'
    )
  end
end
