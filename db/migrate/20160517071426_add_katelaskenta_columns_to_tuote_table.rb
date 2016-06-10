class AddKatelaskentaColumnsToTuoteTable < ActiveRecord::Migration
  def change
    add_column :tuote, :myyntikate, :integer, default: 0, null: false, after: :vihapvm
    add_column :tuote, :myymalakate, :integer, default: 0, null: false, after: :myyntikate
    add_column :tuote, :nettokate, :integer, default: 0, null: false, after: :myymalakate
  end
end
