require File.expand_path('test/permission_helper')
include PermissionHelper

class AddPermissionsToCompanies < ActiveRecord::Migration
  def up
    PermissionHelper.add_item(
      program: 'Ylläpito',
      name: 'Yhtiön tiedot',
      uri: 'pupenext/companies',
      hidden: 'H',
    )
  end

  def down
    PermissionHelper.remove_all(
      uri: 'pupenext/companies',
    )
  end
end
