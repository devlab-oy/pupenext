class AddVientierittelynPainot < ActiveRecord::Migration
  def change
    add_column :yhtion_parametrit, :vientierittelyn_painot, :string, limit: 1, default: '', null: false, after: :vienti_erittelyn_tulostus
  end
end
