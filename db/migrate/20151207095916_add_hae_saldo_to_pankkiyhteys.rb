class AddHaeSaldoToPankkiyhteys < ActiveRecord::Migration
  def change
    add_column :pankkiyhteys, :hae_saldo, :boolean, null: false, default: false, after: :customer_id
  end
end
