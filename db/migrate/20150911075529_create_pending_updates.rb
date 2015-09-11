class CreatePendingUpdates < ActiveRecord::Migration
  def change
    create_table :pending_updates do |t|
      t.string  :yhtio
      t.integer :pending_updatable_id
      t.string  :pending_updatable_type
      t.string  :key
      t.text    :value_type
      t.text    :value
    end

    add_index :pending_updates, :pending_updatable_id
  end
end
