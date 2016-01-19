class AddColumnToTyomaarays < ActiveRecord::Migration
  def change
    add_column :tyomaarays, :vastuuhenkilo, :string, limit: 50, default: '', null: false, after: :suorittaja
  end
end
