require File.expand_path('test/permission_helper')
include PermissionHelper

class AddPermissionsToProductCategories < ActiveRecord::Migration
  def up
    PermissionHelper.add_item(
      program: 'Tuotehallinta',
      name: 'Dynaaminen puu',
      uri: 'pupenext/product_categories',
      hidden: 'H',
    )
  end

  def down
    PermissionHelper.remove_all(
      uri: 'pupenext/product_categories',
    )
  end
end
