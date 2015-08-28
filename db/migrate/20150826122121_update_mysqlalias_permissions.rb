class UpdateMysqlaliasPermissions < ActiveRecord::Migration
  def up
    Company.find_each do |company|
      Current.company = company.yhtio

      Permission.where(nimi: 'mysqlaliasyllapito.php').find_each do |permission|
        permission.update(nimi: 'pupenext/custom_attributes', alanimi: '')
      end

      Keyword::CustomAttribute.where(selitetark_2: '').find_each do |keyword|
        keyword.update(selitetark_2: 'Default')
      end
    end
  end

  def down
    Company.find_each do |company|
      Current.company = company.yhtio

      Permission.where(nimi: 'pupenext/custom_attributes', alanimi: '').find_each do |permission|
        permission.update(nimi: 'mysqlaliasyllapito.php')
      end

      # Update all skips validations (as selitetark_2 is required field).
      # Hope you don't have to rollback.
      Keyword::CustomAttribute.where(selitetark_2: 'Default').update_all(selitetark_2: '')
    end
  end
end
