class SmartenTuoimitustapa < ActiveRecord::Migration
  def up
    add_column :toimitustapa, :smarten_partycode, :string, limit: 100, default: '', null: false, after: :rahdinkuljettaja
  end

  def down
    remove_column :toimitustapa, :smarten_partycode
  end
end
