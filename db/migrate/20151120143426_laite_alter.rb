class LaiteAlter < ActiveRecord::Migration
  def change
    change_column :laite, :valmistajan_sopimus_paattymispaiva, :date
  end
end
