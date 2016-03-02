class AddPickableWorkorder < ActiveRecord::Migration
  def change
    add_column :yhtion_parametrit, :kerataanko_tyomaaraykset, :string, limit: 1, null: false, default: '', after: :kerataanko_valmistukset
  end
end
