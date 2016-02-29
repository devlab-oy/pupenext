class RemoveSallitutAlustat < ActiveRecord::Migration
  def up
    remove_column :toimitustapa, :sallitut_alustat
  end

  def down
    add_column :toimitustapa, :sallitut_alustat, :string, limit: 150, default: '', null: false, after: :sallitut_maat
  end
end
