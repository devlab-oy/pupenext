class AddEnToDynaaminenPuu < ActiveRecord::Migration
  def change
    add_column :dynaaminen_puu, :nimi_en, :string, limit: 120, default: "", null: false, after: :nimi
  end
end
