class CreateJoinTable < ActiveRecord::Migration
  def change
    create_join_table :users, :customers do |t|
      t.index [:user_id]
      t.index [:customer_id]
    end
  end
end
