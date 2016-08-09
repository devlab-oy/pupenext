class ChangeLogmasterPaths < ActiveRecord::Migration
  def up
    Company.find_each do |company|
      Current.company = company.yhtio

      old_name = 'uudelleenlaheta-postnord.php'
      new_name = 'rajapinnat/logmaster/resend_logmaster.php'

      Menu.where(nimi: old_name).update_all(nimi: new_name)
      Permission.where(nimi: old_name).update_all(nimi: new_name)
      UserProfile.where(nimi: old_name).update_all(nimi: new_name)

      old_name = 'synkronoi_tuotteet_ulkoiseen_jarjestelmaan.php'
      new_name = 'rajapinnat/logmaster/synchronize_products.php'

      Menu.where(nimi: old_name).update_all(nimi: new_name)
      Permission.where(nimi: old_name).update_all(nimi: new_name)
      UserProfile.where(nimi: old_name).update_all(nimi: new_name)
    end
  end

  def down
    Company.find_each do |company|
      Current.company = company.yhtio

      old_name = 'rajapinnat/logmaster/resend_logmaster.php'
      new_name = 'uudelleenlaheta-postnord.php'

      Menu.where(nimi: old_name).update_all(nimi: new_name)
      Permission.where(nimi: old_name).update_all(nimi: new_name)
      UserProfile.where(nimi: old_name).update_all(nimi: new_name)

      old_name = 'rajapinnat/logmaster/synchronize_products.php'
      new_name = 'synkronoi_tuotteet_ulkoiseen_jarjestelmaan.php'

      Menu.where(nimi: old_name).update_all(nimi: new_name)
      Permission.where(nimi: old_name).update_all(nimi: new_name)
      UserProfile.where(nimi: old_name).update_all(nimi: new_name)
    end
  end
end
