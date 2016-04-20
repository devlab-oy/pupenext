class AddNakyvyysToYhteyshenkilo < ActiveRecord::Migration
  def change
    add_column :yhteyshenkilo, :verkkokauppa_nakyvyys, :string, after: :verkkokauppa_salasana
  end
end
