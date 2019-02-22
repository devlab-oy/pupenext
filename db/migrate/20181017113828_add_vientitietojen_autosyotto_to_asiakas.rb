class AddVientitietojenAutosyottoToAsiakas < ActiveRecord::Migration
  def up
    add_column :asiakas, :vientitietojen_autosyotto, :char, default: '', null: false, after: :Vienti
  end

    def down
      remove_column :asiakas, :vientitietojen_autosyotto
    end
  end
