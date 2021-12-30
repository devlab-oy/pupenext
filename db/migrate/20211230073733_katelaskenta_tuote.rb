class KatelaskentaTuote < ActiveRecord::Migration
  def change
    add_column :asiakashinta, :myyntikate, :int, limit: 11, default: 0, null: false, after: :hinta
  end
end
