class ExtranetNewsCustomerSegment < ActiveRecord::Migration
  def up
    create_table :uutinen_asiakassegmentti, primary_key: "tunnus", force: :cascade do |t|
      t.string  :yhtio, limit: 5, default: "", null: false
      t.integer :uutistunnus, default: 0, null: false
      t.integer :segmenttitunnus, default: 0, null: false
    end
  end

  def down
    drop_table :uutinen_asiakassegmentti
  end
end
