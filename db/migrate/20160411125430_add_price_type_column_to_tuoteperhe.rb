class AddPriceTypeColumnToTuoteperhe < ActiveRecord::Migration
  def change
  	add_column :tuoteperhe, :hintatyyppi, :string, limit: 1, default: '', null: false, after: :ei_nayteta
  end
end
