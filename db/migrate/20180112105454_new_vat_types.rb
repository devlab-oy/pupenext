class NewVatTypes < ActiveRecord::Migration
  def up
    Company.find_each do |company|
      execute "INSERT INTO `taso` (`yhtio`, `tyyppi`, `taso`, `nimi`) VALUES ('#{company.yhtio}', 'A', 'fi304', 'Vero tavaroiden maahantuonnista EU:n ulkop.');"
      execute "INSERT INTO `taso` (`yhtio`, `tyyppi`, `taso`, `nimi`) VALUES ('#{company.yhtio}', 'A', 'fi310', 'Tavaroiden maahantuonnit EU:n ulkop.');"
    end
  end

  def down
    Company.find_each do |company|
      execute "DELETE FROM taso WHERE yhtio = '#{company.yhtio}' AND tyyppi = 'A' AND taso = 'fi304';"
      execute "DELETE FROM taso WHERE yhtio = '#{company.yhtio}' AND tyyppi = 'A' AND taso = 'fi310';"
    end
  end
end
