class AddToimittajaryhmaToSuppliers < ActiveRecord::Migration
  def change
    add_column :toimi, :toimittajaryhma, :string, limit: 150, null: false, default: '', after: :email
  end
end
