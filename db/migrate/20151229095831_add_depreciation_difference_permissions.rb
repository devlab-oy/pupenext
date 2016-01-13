require File.expand_path('test/permission_helper')
include PermissionHelper

class AddDepreciationDifferencePermissions < ActiveRecord::Migration
  def up
    PermissionHelper.add_item(
      program: 'Kirjanpitoraportit',
      name: 'Hyödykkeiden poistoerot',
      uri: 'pupenext/depreciation_difference'
    )
  end

  def down
    PermissionHelper.remove_all(
      uri: 'pupenext/depreciation_difference'
    )
  end
end
