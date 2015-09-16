class UpdateDeliveryMethodPermissions < ActiveRecord::Migration
  def up
    Company.find_each do |company|
      Current.company = company.yhtio

      Permission.where(nimi: 'yllapito.php', alanimi: 'toimitustapa').find_each do |permission|
        permission.update(nimi: 'pupenext/delivery_methods', alanimi: '')
      end
    end
  end

  def down
    Company.find_each do |company|
      Current.company = company.yhtio

      Permission.where(nimi: 'pupenext/delivery_methods', alanimi: '').find_each do |permission|
        permission.update(nimi: 'yllapito.php', alanimi: 'toimitustapa')
      end
    end
  end
end
