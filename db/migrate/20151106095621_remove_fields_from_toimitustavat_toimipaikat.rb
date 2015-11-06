class RemoveFieldsFromToimitustavatToimipaikat < ActiveRecord::Migration
  def up
    remove_column :toimitustavat_toimipaikat, :yhtio
    remove_column :toimitustavat_toimipaikat, :laatija
    remove_column :toimitustavat_toimipaikat, :muuttaja
    remove_column :toimitustavat_toimipaikat, :luontiaika
    remove_column :toimitustavat_toimipaikat, :muutospvm

    add_index :toimitustavat_toimipaikat, :toimitustapa_tunnus
    add_index :toimitustavat_toimipaikat, :toimipaikka_tunnus
  end

  def down
    add_column :toimitustavat_toimipaikat, :yhtio,      :string, limit: 5,  default: '', null: false
    add_column :toimitustavat_toimipaikat, :laatija,    :string, limit: 50, default: '', null: false, after: :yhtio
    add_column :toimitustavat_toimipaikat, :muuttaja,   :string, limit: 50, default: '', null: false, after: :yhtio
    add_column :toimitustavat_toimipaikat, :luontiaika, :datetime, after: :yhtio
    add_column :toimitustavat_toimipaikat, :muutospvm,  :datetime, after: :yhtio

    remove_index :toimitustavat_toimipaikat, column: :toimitustapa_tunnus
    remove_index :toimitustavat_toimipaikat, column: :toimipaikka_tunnus
    add_index :toimitustavat_toimipaikat, :yhtio, name: 'yhtio_index'
  end
end
