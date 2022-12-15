class LaskuToimitusaikaikkuna < ActiveRecord::Migration
  def change
    add_column :lasku, :toimitusaikaikkuna, :int, limit: 11, default: 0, null: false, after: :toimitustapa
  end
end