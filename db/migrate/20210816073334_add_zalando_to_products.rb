class AddZalandoToProducts < ActiveRecord::Migration
  def up
    add_column :tuote, :zalando_nakyvyys, :string, limit: 1, null: false, default: "",  after: :tayte
  end
  def down
    remove_column :tuote, :zalando_nakyvyys
  end
end
