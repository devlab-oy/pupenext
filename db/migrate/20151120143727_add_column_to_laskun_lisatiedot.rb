class AddColumnToLaskunLisatiedot < ActiveRecord::Migration
  def change
    add_column :laskun_lisatiedot, :sopimus_numero, :string, limit: 50, default: '', after: :sopimus_lisatietoja2
  end
end
