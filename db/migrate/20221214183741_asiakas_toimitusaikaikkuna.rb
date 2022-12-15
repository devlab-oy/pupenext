class AsiakasToimitusaikaikkuna < ActiveRecord::Migration
  def change
    add_column :asiakas, :toimitusaikaikkuna, :int, limit: 11, default: 0, null: false, after: :toimitustapa
  end
end