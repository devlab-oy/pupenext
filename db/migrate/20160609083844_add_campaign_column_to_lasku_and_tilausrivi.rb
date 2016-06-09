class AddCampaignColumnToLaskuAndTilausrivi < ActiveRecord::Migration
  def change
    add_column :lasku,      :kampanja, :integer, limit: 4, default: 0, null: false, after: :piiri
    add_column :tilausrivi, :kampanja, :integer, limit: 4, default: 0, null: false, after: :suuntalava
  end
end
