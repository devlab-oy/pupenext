class TekstiiliTietojaTuotteelle < ActiveRecord::Migration
  def up
    add_column :tuote, :pesuohje, :text, null: false, after: :ostokommentti
    add_column :tuote, :paalismateriaali, :text, null: false, after: :pesuohje
    add_column :tuote, :vuorimateriaali, :text, null: false , after: :paalismateriaali
    add_column :tuote, :tayte, :text, null: false, after: :vuorimateriaali
  end
  def down
    remove_column :tuote, :pesuohje
    remove_column :tuote, :paalismateriaali
    remove_column :tuote, :vuorimateriaali
    remove_column :tuote, :tayte
  end
end
