class RemoveUnusedColumns < ActiveRecord::Migration
  def change
    change_table :sarjanumeroseuranta do |t|
      t.remove :massa
      t.remove :korkeus
      t.remove :leveys
      t.remove :syvyys
      t.remove :halkaisija
    end

    change_table :tilausrivin_lisatiedot do |t|
      t.remove :rahtikirja_id
      t.remove :juoksu
      t.remove :tilauksen_paino
      t.remove :kuljetuksen_rekno
      t.remove :asiakkaan_tilausnumero
      t.remove :asiakkaan_rivinumero
      t.remove :matkakoodi
      t.remove :konttinumero
      t.remove :sinettinumero
      t.remove :kontin_kilot
      t.remove :kontin_taarapaino
      t.remove :kontin_isokoodi
      t.remove :kontin_mrn
      t.remove :kontin_maxkg
      t.remove :konttien_maara
    end

    change_table :laskun_lisatiedot do |t|
      t.remove :konttiviite
      t.remove :konttimaara
      t.remove :konttityyppi
      t.remove :rullamaara
      t.remove :matkatiedot
      t.remove :satamavahvistus_pvm
      t.remove :matkakoodi
    end
  end
end
