class AddToimipisteColumnToLaite < ActiveRecord::Migration
  def change
  	add_column :laite, :toimipiste, :string, limit: 12, default: '', null: false, after: :sijainti
  end
end
