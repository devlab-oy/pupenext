class AddEditilausSuoratoimitusToCompany < ActiveRecord::Migration
  def change
    add_column :yhtion_parametrit, :editilaus_suoratoimitus, :string, limit: 1, default: '', null: false, after: :suoratoim_lisamyynti_osto
  end
end
