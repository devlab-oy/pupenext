class AddTilaukselleMittatiedotParameterToCompany < ActiveRecord::Migration
  def up
    add_column :yhtion_parametrit, :tilaukselle_mittatiedot, :string, limit: 1, default: '', null: false, after: :tilauksen_myyntieratiedot
  end

  def down
    remove_column :yhtion_parametrit, :tilaukselle_mittatiedot
  end
end
