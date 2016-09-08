class AddExtranetLogoToYhtionParametrit < ActiveRecord::Migration
  def change
    add_column :yhtion_parametrit, :extranet_logo, :string, limit: 100, default: '', null: false, after: :lasku_logo_koko
  end
end
