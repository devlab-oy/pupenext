class AddTaxToTiliointisaanto < ActiveRecord::Migration
  def change
    add_column :tiliointisaanto, :alv, :string, limit: 1, default: '', null: false, after: :kustp
  end
end
