class AddKoodiColumnToTyomaarays < ActiveRecord::Migration
  def up
    add_column :tyomaarays, :koodi, :string, limit: 60, default: '', null: false, after: :valmnro
  end

  def down
    remove_column :tyomaarays, :koodi
  end
end
