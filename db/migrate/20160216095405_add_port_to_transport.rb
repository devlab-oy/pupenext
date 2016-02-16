class AddPortToTransport < ActiveRecord::Migration
  def up
    add_column :transports, :port, :integer, after: :hostname
  end

  def down
    remove_column :transports, :port
  end
end
