class AddTuotekommenttiTilausrivilleToCompany < ActiveRecord::Migration
  def change
    add_column :yhtion_parametrit, :tuotekommentti_tilausriville, :string, limit: 1, default: '', null: false, after: :naytetaan_katteet_tilauksella
  end
end
