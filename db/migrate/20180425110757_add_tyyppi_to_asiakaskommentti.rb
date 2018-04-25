class AddTyyppiToAsiakaskommentti < ActiveRecord::Migration
  def change
    add_column :asiakaskommentti, :tyyppi, :char, default: '', null: false, after: :ytunnus
  end

  def down
    remove_column :asiakaskommentti, :tyyppi
  end
end
