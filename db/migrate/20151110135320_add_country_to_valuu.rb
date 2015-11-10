class AddCountryToValuu < ActiveRecord::Migration
  def change
    add_column :valuu, :country, :string
  end
end
