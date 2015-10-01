class RemoveValueTypeFromPendingUpdates < ActiveRecord::Migration
  def up
    remove_column :pending_updates, :value_type
  end

  def down
    add_column :pending_updates, :value_type, :text
  end
end
