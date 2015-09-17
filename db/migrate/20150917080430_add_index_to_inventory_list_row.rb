class AddIndexToInventoryListRow < ActiveRecord::Migration
  def change
    add_index :inventointilistarivi, [ :yhtio, :otunnus, :tuoteno ]
  end
end
