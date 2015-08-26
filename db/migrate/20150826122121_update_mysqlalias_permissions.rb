class UpdateMysqlaliasPermissions < ActiveRecord::Migration
  def up
    Company.find_each do |company|
      Current.company = company.yhtio

      Permission.where(nimi: 'mysqlaliasyllapito.php').find_each do |permission|
        permission.update(nimi: 'pupenext/custom_attributes', alanimi: '')
      end
    end
  end

  def down
    Company.find_each do |company|
      Current.company = company.yhtio

      Permission.where(nimi: 'pupenext/custom_attributes', alanimi: '').find_each do |permission|
        permission.update(nimi: 'mysqlaliasyllapito.php')
      end
    end
  end
end
