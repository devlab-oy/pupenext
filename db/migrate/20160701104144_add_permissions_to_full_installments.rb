require File.expand_path('test/permission_helper')
include PermissionHelper

class AddPermissionsToFullInstallments < ActiveRecord::Migration
  def up
    PermissionHelper.add_item(
      program: 'Varastoraportit',
      name: 'Maksetut ennakkomaksut',
      uri: 'pupenext/full_installments'
    )
  end

  def down
    PermissionHelper.remove_all(
      uri: 'pupenext/full_installments'
    )
  end
end
