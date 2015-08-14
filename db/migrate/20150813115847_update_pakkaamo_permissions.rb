class UpdatePakkaamoPermissions < ActiveRecord::Migration
  def up
    # We must loop all companies, because we need Current.company
    Company.all.each do |company|
      Current.company = company.yhtio

      Permission.where(nimi: 'yllapito.php', alanimi: 'pakkaamo')
        .update_all(nimi: 'pupenext/packing_areas', alanimi: '')
    end
  end

  def down
    # We must loop all companies, because we need Current.company
    Company.all.each do |company|
      Current.company = company.yhtio

      Permission.where(nimi: 'pupenext/packing_areas', alanimi: '')
        .update_all(nimi: 'yllapito.php', alanimi: 'pakkaamo')
    end
  end
end
