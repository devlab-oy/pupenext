class NewVatTypes < ActiveRecord::Migration
  def up
    Company.find_each do |company|
      execute "INSERT INTO `taso` (`yhtio`, `tyyppi`, `taso`, `nimi`, `poisto_vastatili`, `poistoero_tili`, `poistoero_vastatili`) VALUES ('#{company.yhtio}', 'A', 'fi304', 'Vero tavaroiden maahantuonnista EU:n ulkop.', '', '', '');"
      execute "INSERT INTO `taso` (`yhtio`, `tyyppi`, `taso`, `nimi`, `poisto_vastatili`, `poistoero_tili`, `poistoero_vastatili`) VALUES ('#{company.yhtio}', 'A', 'fi310_10', 'Tavaroiden maahantuonnit EU:n ulkop. alv 10', '', '', '');"
      execute "INSERT INTO `taso` (`yhtio`, `tyyppi`, `taso`, `nimi`, `poisto_vastatili`, `poistoero_tili`, `poistoero_vastatili`) VALUES ('#{company.yhtio}', 'A', 'fi310_14', 'Tavaroiden maahantuonnit EU:n ulkop. alv 14', '', '', '');"
      execute "INSERT INTO `taso` (`yhtio`, `tyyppi`, `taso`, `nimi`, `poisto_vastatili`, `poistoero_tili`, `poistoero_vastatili`) VALUES ('#{company.yhtio}', 'A', 'fi310_24', 'Tavaroiden maahantuonnit EU:n ulkop. alv 24', '', '', '');"
    end
  end

  def down
    Company.find_each do |company|
      execute "DELETE FROM taso WHERE yhtio = '#{company.yhtio}' AND tyyppi = 'A' AND taso = 'fi304';"
      execute "DELETE FROM taso WHERE yhtio = '#{company.yhtio}' AND tyyppi = 'A' AND taso = 'fi310_10';"
      execute "DELETE FROM taso WHERE yhtio = '#{company.yhtio}' AND tyyppi = 'A' AND taso = 'fi310_14';"
      execute "DELETE FROM taso WHERE yhtio = '#{company.yhtio}' AND tyyppi = 'A' AND taso = 'fi310_24';"
    end
  end
end
