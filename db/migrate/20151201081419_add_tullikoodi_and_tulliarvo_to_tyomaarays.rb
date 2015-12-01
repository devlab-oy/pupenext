class AddTullikoodiAndTulliarvoToTyomaarays < ActiveRecord::Migration
  def up
    add_column :tyomaarays, :tullikoodi, :string, limit: 8, default: '', null: false, after: :koodi
    add_column :tyomaarays, :tulliarvo, :decimal, precision: 12, scale: 2, default: 0.0, null: false, after: :tullikoodi
  end

  def down
    remove_column :tyomaarays, :tullikoodi
    remove_column :tyomaarays, :tulliarvo
  end
end
