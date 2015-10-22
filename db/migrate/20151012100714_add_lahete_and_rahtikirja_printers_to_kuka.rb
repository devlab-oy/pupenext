class AddLaheteAndRahtikirjaPrintersToKuka < ActiveRecord::Migration
  def up
    add_column :kuka, :lahetetulostin, :integer, default: 0, null: false, after: :kuittitulostin
    add_column :kuka, :rahtikirjatulostin, :integer, default: 0, null: false, after: :lahetetulostin
  end

  def down
    remove_column :kuka, :lahetetulostin
    remove_column :kuka, :rahtikirjatulostin
  end
end
