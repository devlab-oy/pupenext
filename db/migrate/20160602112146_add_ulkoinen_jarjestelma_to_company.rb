class AddUlkoinenJarjestelmaToCompany < ActiveRecord::Migration
  def change
    add_column :yhtion_parametrit, :ulkoinen_jarjestelma, :string, limit: 1, default: '', null: false, after: :pakollinen_varasto
  end
end
