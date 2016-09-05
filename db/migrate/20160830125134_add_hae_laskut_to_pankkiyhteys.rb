class AddHaeLaskutToPankkiyhteys < ActiveRecord::Migration
  def change
    add_column :pankkiyhteys, :hae_laskut, :boolean, null: false, default: false, after: :hae_factoring
  end
end
