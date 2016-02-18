class AddVerkkokauppaSalasanaToYhteyshenkilo < ActiveRecord::Migration
  def change
    add_column :yhteyshenkilo, :verkkokauppa_salasana, :string, after: :aktivointikuittaus
  end
end
