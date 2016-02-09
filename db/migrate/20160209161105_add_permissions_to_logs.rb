require File.expand_path('test/permission_helper')
include PermissionHelper

class AddPermissionsToLogs < ActiveRecord::Migration
  def up
    PermissionHelper.add_item(
      program: 'Ylläpito',
      name: 'Lokitiedostot',
      uri: 'pupenext/logs'
    )
  end

  def down
    PermissionHelper.remove_all(
      uri: 'pupenext/logs'
    )
  end
end
