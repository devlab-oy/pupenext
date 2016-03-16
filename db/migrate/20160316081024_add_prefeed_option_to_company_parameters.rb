class AddPrefeedOptionToCompanyParameters < ActiveRecord::Migration
  def change
    add_column :yhtion_parametrit, :tilausrivin_esisyotto, :string, limit: 1, null: false, default: '', after: :tilausrivien_toimitettuaika
  end
end
