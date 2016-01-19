class AddHaeFactoringToPankkiyhteys < ActiveRecord::Migration
  def change
    add_column :pankkiyhteys, :hae_factoring, :boolean, null: false, default: false, after: :hae_saldo
  end
end
