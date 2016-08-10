class CashReceiptDateParameter < ActiveRecord::Migration
  def change
    add_column :yhtion_parametrit, :kateiskuitin_paivays, :string, limit: 1, default: '', null: false, after: :laskutus_tulevaisuuteen
  end
end
