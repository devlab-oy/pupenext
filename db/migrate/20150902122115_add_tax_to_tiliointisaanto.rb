class AddTaxToTiliointisaanto < ActiveRecord::Migration
  def change
    add_column :tiliointisaanto, :alv, :decimal, precision: 5, scale: 2, default: nil, null: true, after: :kustp
  end
end
