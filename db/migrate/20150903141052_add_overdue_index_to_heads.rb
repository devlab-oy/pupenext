class AddOverdueIndexToHeads < ActiveRecord::Migration
  def change
    add_index :lasku, [:yhtio, :tila, :erpcm]
  end
end
