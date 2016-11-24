class AddMinimimaaraPyoristysParameter < ActiveRecord::Migration
  def up
    add_column :yhtion_parametrit, :minimimaara_pyoristys, :string, limit: 1, default: '', after: :myyntiera_pyoristys

    Company.find_each do |company|
      Current.company = company.yhtio

      company.parameter.update_attribute(:minimimaara_pyoristys, company.parameter.myyntiera_pyoristys)
    end
  end

  def down
    remove_column :yhtion_parametrit, :minimimaara_pyoristys
  end
end
