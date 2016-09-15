require File.expand_path('test/permission_helper')
include PermissionHelper

class AddPermissionToUsers < ActiveRecord::Migration
  def up
    PermissionHelper.add_item(
      program: 'Käyttäjät ja valikot',
      name: 'Käyttäjähallinta',
      uri: 'pupenext/users',
    )
  end

  def down
    PermissionHelper.remove_all uri: 'pupenext/users'
  end
end
