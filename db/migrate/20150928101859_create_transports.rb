class CreateTransports < ActiveRecord::Migration
  def change
    create_table :transports do |t|
      t.references :customer, index: true
      t.string :hostname
      t.string :username
      t.string :password
      t.string :path

      t.timestamps null: false
    end
  end
end
