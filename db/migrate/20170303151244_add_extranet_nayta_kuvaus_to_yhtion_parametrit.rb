class AddExtranetNaytaKuvausToYhtionParametrit < ActiveRecord::Migration
  def up
    add_column :yhtion_parametrit, :extranet_nayta_kuvaus, :char, default: '', null: false, after: :extranet_nayta_saldo
  end

  def down
    remove_column :yhtion_parametrit, :extranet_nayta_kuvaus
  end
end
