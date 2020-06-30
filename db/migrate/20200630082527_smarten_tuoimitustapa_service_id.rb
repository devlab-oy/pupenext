class SmartenTuoimitustapaServiceId < ActiveRecord::Migration
  def up
    add_column :toimitustapa, :smarten_serviceid, :string, limit: 100, default: '', null: false, after: :smarten_partycode
  end

  def down
    remove_column :toimitustapa, :smarten_serviceid
  end
end
