require File.expand_path('test/permission_helper')
include PermissionHelper

class AddPermissionsToCategories < ActiveRecord::Migration
  def up
    PermissionHelper.add_item(
      program: 'Tuotehallinta',
      name: 'Dynaaminen puu',
      uri: 'pupenext/categories',
      hidden: 'H',
    )
  end

  def down
    PermissionHelper.remove_all(
      uri: 'pupenext/categories',
    )
  end
end
