class UpdatePackagePermission < ActiveRecord::Migration
  def up
    Company.find_each do |company|
      Current.company = company.yhtio

      Permission.where(nimi: 'yllapito.php', alanimi: 'pakkaus').find_each do |permission|
        permission.update(nimi: 'pupenext/packages', alanimi: '')
      end
    end
  end

  def down
    Company.find_each do |company|
      Current.company = company.yhtio

      Permission.where(nimi: 'pupenext/packages', alanimi: '').find_each do |permission|
        permission.update(nimi: 'yllapito.php', alanimi: 'pakkaus')
      end
    end
  end
end
