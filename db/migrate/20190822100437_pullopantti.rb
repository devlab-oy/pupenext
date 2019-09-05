class Pullopantti < ActiveRecord::Migration
  def up
    add_column :sarjanumeroseuranta, :panttirivitunnus, :int, default: nil, null: true, after: :myyntirivitunnus
  end
  def down
    remove_column :sarjanumeroseuranta, :panttirivitunnus
  end
end
