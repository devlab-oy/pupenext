class AddMyyntiJtHuomParameterToCompany < ActiveRecord::Migration
  def up
    add_column :yhtion_parametrit, :myynti_jt_huom, :string, limit: 1, default: '', null: false, after: :puute_jt_kerataanko
  end

  def down
    remove_column :yhtion_parametrit, :myynti_jt_huom
  end
end
