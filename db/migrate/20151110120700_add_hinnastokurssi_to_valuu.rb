class AddHinnastokurssiToValuu < ActiveRecord::Migration
  def change
    add_column :valuu,
               :hinnastokurssi,
               :decimal,
               precision: 15,
               scale:     9,
               default:   0.0,
               null:      false,
               after:     :intrastat_kurssi
  end
end
