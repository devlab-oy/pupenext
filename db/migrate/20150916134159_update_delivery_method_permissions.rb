require File.expand_path('test/permission_helper')
include PermissionHelper

class UpdateDeliveryMethodPermissions < ActiveRecord::Migration
  def up
    PermissionHelper.add_item(
      program: 'Ylläpito',
      name: 'Toimitustavat',
      uri: 'pupenext/delivery_methods'
    )
  end

  def down
    PermissionHelper.remove_all(
      uri: 'pupenext/delivery_methods'
    )
  end
end
