class ExtranetEmailAddressYhtionParamaetreihin < ActiveRecord::Migration
  def up
    add_column :yhtion_parametrit, :hyvaksyttavat_extranet_email, :string, limit: 255, default: '', null: false, after: :ostotilaus_email
  end

  def down
    remove_column :yhtion_parametrit, :hyvaksyttavat_extranet_email
  end
end
