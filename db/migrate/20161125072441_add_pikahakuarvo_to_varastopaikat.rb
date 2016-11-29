class AddPikahakuarvoToVarastopaikat < ActiveRecord::Migration
  def change
    add_column :varastopaikat, :pikahakuarvo, :integer, default: 0, after: :ulkoinen_jarjestelma
  end
end
