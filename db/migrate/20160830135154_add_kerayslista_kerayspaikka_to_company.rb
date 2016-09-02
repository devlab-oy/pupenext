class AddKerayslistaKerayspaikkaToCompany < ActiveRecord::Migration
  def change
    add_column :yhtion_parametrit, :kerayslista_kerayspaikka, :string, limit: 1, default: '', null: false, after: :purkulistan_asettelu
  end
end
