class ValmistuksenKommentitLaskulle < ActiveRecord::Migration
  def change
     add_column :lasku, :valmistuksen_lisatiedot, :text, after: :maksuteksti
   end
end
