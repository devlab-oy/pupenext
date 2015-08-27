class PankkiyhteystiedotPermissions < ActiveRecord::Migration
  def up
    Company.find_each do |company|
      Current.company = company.yhtio

      Permission.where(nimi: 'yllapito.php', alanimi: 'pankkiyhteystiedot').find_each do |permission|
        permission.update(nimi: 'pupenext/bank_details', alanimi: '')
      end
    end
  end

  def down
    Company.find_each do |company|
      Current.company = company.yhtio

      Permission.where(nimi: 'pupenext/bank_details', alanimi: '').find_each do |permission|
        permission.update(nimi: 'yllapito.php', alanimi: 'pankkiyhteystiedot')
      end
    end
  end
end
