class ConnectionName < ActiveRecord::Migration
  def up
      add_column :transports, :transport_name, :string, limit: 60, default: "", null: false, after: :transportable_type
    end

    def down
      remove_column :transports, :transport_name
    end
end
