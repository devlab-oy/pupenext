class Luontitapalaskunlisatiedot < ActiveRecord::Migration
  def change
  	add_column :laskun_lisatiedot, :luontitapa, :string, limit: 30, default: '', null: false, after: :otunnus
  end
end