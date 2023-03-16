class ToimitustapaEiLisakulja < ActiveRecord::Migration
  def change
    add_column :toimitustapa, :ei_lisakulja_kateismyynneille, :string, limit: 1, default: '', null: false, after: :lisakulu_summa
  end
end