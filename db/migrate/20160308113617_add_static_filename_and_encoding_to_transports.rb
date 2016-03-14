class AddStaticFilenameAndEncodingToTransports < ActiveRecord::Migration
  def change
    add_column :transports, :filename, :string
    add_column :transports, :encoding, :string
  end
end
