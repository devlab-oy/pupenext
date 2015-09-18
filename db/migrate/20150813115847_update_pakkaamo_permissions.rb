class UpdatePakkaamoPermissions < ActiveRecord::Migration
  def up
    # We must loop all companies, because we need Current.company
    Company.find_each do |company|
      Current.company = company.yhtio

      Permission.where(nimi: 'yllapito.php', alanimi: 'pakkaamo').find_each do |permission|
        permission.update(nimi: 'pupenext/packing_areas', alanimi: '')
      end
    end
  end

  def down
    # We must loop all companies, because we need Current.company
    Company.find_each do |company|
      Current.company = company.yhtio

      Permission.where(nimi: 'pupenext/packing_areas', alanimi: '').find_each do |permission|
        permission.update(nimi: 'yllapito.php', alanimi: 'pakkaamo')
      end
    end
  end
end
