class AutomaattinenVientitietojenSyotto < ActiveRecord::Migration
  def up
      add_column :yhtion_parametrit, :vientitietojen_autosyotto, :string, limit: 1, default: '', null: false, after: :vientikiellon_ohitus
    end
    def down
      remove_column :yhtion_parametrit, :vientitietojen_autosyotto
    end
end
