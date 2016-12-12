require File.expand_path('test/permission_helper')
include PermissionHelper

class AddPermissionsToWoo < ActiveRecord::Migration
  def up
    PermissionHelper.add_item(
      program: 'Ylläpito',
      name: 'WooCommerce API',
      uri: 'woo/complete_order',
      hidden: 'H',
    )
  end

  def down
    PermissionHelper.remove_all uri: 'woo/complete_order'
  end
end
