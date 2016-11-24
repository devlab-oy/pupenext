class LaskuVerkkotunnus < ActiveRecord::Migration
  def change
    change_column :lasku, :verkkotunnus, :string, limit: 76, default: '', null: false
  end
end
