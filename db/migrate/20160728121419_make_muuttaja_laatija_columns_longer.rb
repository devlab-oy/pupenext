class MakeMuuttajaLaatijaColumnsLonger < ActiveRecord::Migration
  def change
    change_column :oikeu, :muuttaja, :string, limit: 50, null: false, default: ''
    change_column :oikeu, :laatija,  :string, limit: 50, null: false, default: ''

    change_column :laite, :muuttaja, :string, limit: 50, null: false, default: ''
    change_column :laite, :laatija,  :string, limit: 50, null: false, default: ''

    change_column :laitteen_sopimukset, :muuttaja, :string, limit: 50, null: false, default: ''
    change_column :laitteen_sopimukset, :laatija,  :string, limit: 50, null: false, default: ''

    change_column :sahkoisen_lahetteen_rivit, :muuttaja, :string, limit: 50, null: false, default: ''
    change_column :sahkoisen_lahetteen_rivit, :laatija,  :string, limit: 50, null: false, default: ''

    change_column :tuotteen_toimittajat_pakkauskoot, :muuttaja, :string, limit: 50, null: false, default: ''
    change_column :tuotteen_toimittajat_pakkauskoot, :laatija,  :string, limit: 50, null: false, default: ''

    change_column :tyomaarayksen_tapahtumat, :laatija,  :string, limit: 50, null: false, default: ''
  end
end
