require File.expand_path('test/permission_helper')
include PermissionHelper

class AddDataImportPermissions < ActiveRecord::Migration
  def up
    PermissionHelper.add_item(
      program: 'Tuotehallinta',
      name: 'Data import',
      uri: 'pupenext/data_import'
    )
  end

  def down
    PermissionHelper.remove_all(
      uri: 'pupenext/data_import'
    )
  end
end
