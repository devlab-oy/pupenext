class YhteystiedotVarastolle < ActiveRecord::Migration
  def up
    add_column :varastopaikat, :email, :string, limit: 100, default: '', null: false, after: :maa
    add_column :varastopaikat, :puhelin, :string, limit: 100, default: '', null: false, after: :email
  end

  def down
    remove_column :varastopaikat, :email
    remove_column :varastopaikat, :puhelin
  end
end
