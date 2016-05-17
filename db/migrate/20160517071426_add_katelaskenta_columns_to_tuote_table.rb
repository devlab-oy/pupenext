class AddKatelaskentaColumnsToTuoteTable < ActiveRecord::Migration
  def change
    add_column :tuote, :myyntikate, :decimal, precision: 12, scale: 2, default: 0.0, null: false, after: :vihapvm
    add_column :tuote, :myymalakate, :decimal, precision: 12, scale: 2, default: 0.0, null: false, after: :myyntikate
    add_column :tuote, :nettokate, :decimal, precision: 12, scale: 2, default: 0.0, null: false, after: :myymalakate
  end
end
