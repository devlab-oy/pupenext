class AddColumnToLaskunLisatiedot < ActiveRecord::Migration
  def up
    add_column :laskun_lisatiedot, :sopimus_numero, :string, limit: 50, default: '', after: :sopimus_lisatietoja2
  end

  def down
    remove_column :laskun_lisatiedot, :sopimus_numero
  end
end
