class IltasiivoKassamyynti < ActiveRecord::Migration
  def up
    add_column :yhtion_parametrit, :iltasiivo_mitatoi_kassamyynti_tilauksia, :string, limit: 150, default: '', null: false, after: :iltasiivo_mitatoi_ext_tilauksia
  end

  def down
    remove_column :yhtion_parametrit, :iltasiivo_mitatoi_kassamyynti_tilauksia
  end
end
