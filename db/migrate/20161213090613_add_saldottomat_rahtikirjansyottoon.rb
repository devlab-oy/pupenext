class AddSaldottomatRahtikirjansyottoon < ActiveRecord::Migration
  def change
    add_column :yhtion_parametrit, :saldottomat_rahtikirjansyottoon, :string, limit: 1, default: '', null: false, after: :rahtikirjojen_esisyotto
  end
end
