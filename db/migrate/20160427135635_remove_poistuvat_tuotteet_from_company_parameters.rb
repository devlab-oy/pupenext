class RemovePoistuvatTuotteetFromCompanyParameters < ActiveRecord::Migration
  def up
    remove_column :yhtion_parametrit, :poistuvat_tuotteet
  end

  def down
    add_column :yhtion_parametrit, :poistuvat_tuotteet, :string, limit: 1, default: '', null: false, after: :nimityksen_muutos_tilauksella
  end
end
