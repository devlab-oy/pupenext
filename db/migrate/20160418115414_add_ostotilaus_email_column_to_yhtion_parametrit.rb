class AddOstotilausEmailColumnToYhtionParametrit < ActiveRecord::Migration
  def change
  	add_column :yhtion_parametrit, :ostotilaus_email, :string, limit: 100, default: '', null: false, after: :hyvaksyttavia_tilauksia_email
  end
end
