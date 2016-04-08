require File.expand_path('test/permission_helper')
include PermissionHelper

class AddPermissionsToMailServers < ActiveRecord::Migration
  def up
    PermissionHelper.add_item(
      program: 'Ylläpito',
      name: 'Sähköpostipalvelimet',
      uri: 'pupenext/mail_servers'
    )
  end

  def down
    PermissionHelper.remove_all(
      uri: 'pupenext/mail_servers'
    )
  end
end
