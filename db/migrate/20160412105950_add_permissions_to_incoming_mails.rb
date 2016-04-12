require File.expand_path('test/permission_helper')
include PermissionHelper

class AddPermissionsToIncomingMails < ActiveRecord::Migration
  def up
    PermissionHelper.add_item(
      program: 'Ylläpito',
      name: 'Haetut sähköpostit',
      uri: 'pupenext/incoming_mails'
    )
  end

  def down
    PermissionHelper.remove_all(
      uri: 'pupenext/incoming_mails'
    )
  end
end
