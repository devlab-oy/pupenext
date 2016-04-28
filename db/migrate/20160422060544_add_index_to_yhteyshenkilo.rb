class AddIndexToYhteyshenkilo < ActiveRecord::Migration
  def change
    add_index :yhteyshenkilo, [ :yhtio, :tyyppi, :liitostunnus, :rooli ], name: "yhtio_tyyppi_liitostunnus_rooli"
  end
end
