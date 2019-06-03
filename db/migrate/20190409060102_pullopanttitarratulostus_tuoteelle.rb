class PullopanttitarratulostusTuoteelle < ActiveRecord::Migration
  def up
    add_column :tuote, :pullopanttitarratulostus_kerayksessa, :string, limit: 12, default: '', null: false, after: :automaattinen_sarjanumerointi
  end
  def down
    remove_column :tuote, :pullopanttitarratulostus_kerayksessa
  end
end
