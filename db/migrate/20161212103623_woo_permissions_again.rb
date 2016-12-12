require File.expand_path('test/permission_helper')
include PermissionHelper

class WooPermissionsAgain < ActiveRecord::Migration
  def up
    PermissionHelper.remove_all uri: 'woo/complete_order'

    PermissionHelper.add_item(
      program: 'Ylläpito',
      name: 'WooCommerce API',
      uri: 'woo_complete_order',
      hidden: 'H',
    )
  end

  def down
    PermissionHelper.remove_all uri: 'woo_complete_order'
  end
end
