class AddColumnToTyomaarayksenTapahtumat < ActiveRecord::Migration
  def change
    add_column :tyomaarayksen_tapahtumat, :vastuuhenkilo, :string, limit: 60, default: '', null: false, after: :tyostatus_selite
  end
end
