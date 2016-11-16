class AddYhteyshenkiloSidosToCompany < ActiveRecord::Migration
  def change
    add_column :yhtion_parametrit, :yhteyshenkiloiden_sidos, :string, limit: 1, default: '', null: false, after: :tilauksen_yhteyshenkilot
  end
end
