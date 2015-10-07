class FastEnnakkolaskuParameter < ActiveRecord::Migration
  def up
      add_column :yhtion_parametrit, :ennakkolasku_myyntitilaukselta, :string, limit: 1, default: '', null: false, after: :maksusopimus_toimitus
    end

    def down
      remove_column :yhtion_parametrit, :ennakkolasku_myyntitilaukselta
    end
end
