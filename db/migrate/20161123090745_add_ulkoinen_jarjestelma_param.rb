class AddUlkoinenJarjestelmaParam < ActiveRecord::Migration
  def change
    add_column :yhtion_parametrit, :ulkoinen_jarjestelma_lukko, :string, default: '', limit: 1, after: :ulkoinen_jarjestelma
  end
end
