require File.expand_path('test/permission_helper')
include PermissionHelper

class AddProductKeywordExportMenu < ActiveRecord::Migration
  def up
    PermissionHelper.add_item(
      program: 'Tuotehallinta',
      name: 'Data Export',
      uri: 'pupenext/data_export'
    )
  end

  def down
    PermissionHelper.remove_all(
      uri: 'pupenext/data_export'
    )
  end
end
