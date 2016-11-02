class ModifyVerkkotunnus < ActiveRecord::Migration
  def change
    change_column :asiakas, :verkkotunnus, :string, limit: 76, default: '', null: false
  end
end
