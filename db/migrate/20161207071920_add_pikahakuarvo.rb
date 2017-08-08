class AddPikahakuarvo < ActiveRecord::Migration
  def change
    add_column :yhtion_toimipaikat, :pikahakuarvo, :integer, default: 0, after: :projekti
  end
end
