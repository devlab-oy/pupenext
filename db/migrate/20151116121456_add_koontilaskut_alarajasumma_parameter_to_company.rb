class AddKoontilaskutAlarajasummaParameterToCompany < ActiveRecord::Migration
  def up
    add_column :yhtion_parametrit, :koontilaskut_alarajasumma, :decimal, precision: 12, scale: 2, default: 0.0, null: false, after: :koontilaskut_yhdistetaan
  end

  def down
    remove_column :yhtion_parametrit, :koontilaskut_alarajasumma
  end
end
