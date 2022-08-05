class UusiKenttaLaskulle < ActiveRecord::Migration
  def up
    add_column :lasku, :tilaus_valmis_toiminto, :string, limit: 100, default: '', null: false, after: :piiri
    add_column :lasku, :tarkista_ennen_laskutusta, :string, limit: 1, default: '', null: false, after: :tilaus_valmis_toiminto
  end

  def down
    remove_column :lasku, :tilaus_valmis_toiminto
    remove_column :lasku, :tarkista_ennen_laskutusta
  end
end
