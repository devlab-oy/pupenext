class CompanyParameterAsiakasmyyjaTilaukselle < ActiveRecord::Migration
  def up
      add_column :yhtion_parametrit, :asiakasmyyja_tilaukselle, :string, limit: 1, default: '', null: false, after: :myyntitilauksen_toimipaikka
  end
  def down
    remove_column :yhtion_parametrit, :asiakasmyyja_tilaukselle
  end
end
