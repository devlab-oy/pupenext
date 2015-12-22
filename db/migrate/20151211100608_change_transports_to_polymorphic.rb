class ChangeTransportsToPolymorphic < ActiveRecord::Migration
  def change
    remove_column :transports, :customer_id

    add_column :transports, :transportable_id, :integer, after: :id
    add_column :transports, :transportable_type, :string, after: :transportable_id
    add_index :transports, :transportable_id
  end
end
