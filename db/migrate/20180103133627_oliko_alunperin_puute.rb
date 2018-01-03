class OlikoAlunperinPuute < ActiveRecord::Migration
  def up
    add_column :tilausrivin_lisatiedot, :alunperin_puute, :integer, default: 0, null: false, after: :ei_nayteta
  end

  def down
    remove_column :tilausrivin_lisatiedot, :alunperin_puute
  end
end
