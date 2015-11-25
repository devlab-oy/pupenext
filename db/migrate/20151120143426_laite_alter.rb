class LaiteAlter < ActiveRecord::Migration
  def up
    change_column :laite, :valmistajan_sopimus_paattymispaiva, :date
  end

  def down
    change_column :laite, :valmistajan_sopimus_paattymispaiva, :datetime
  end
end
