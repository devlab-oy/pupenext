class AddAsiakasviivakooditoAsiakas < ActiveRecord::Migration
  def up
    add_column :asiakas, :asiakasviivakoodi, :char, default: '', null: false, after: :Koontilahete_kollitiedot
  end

    def down
      remove_column :asiakas, :asiakasviivakoodi
    end
  end
