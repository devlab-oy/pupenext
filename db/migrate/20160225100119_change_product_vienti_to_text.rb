class ChangeProductVientiToText < ActiveRecord::Migration
  def change
    change_column_default :tuote, :vienti, nil
    change_column :tuote, :vienti, :text
  end
end
