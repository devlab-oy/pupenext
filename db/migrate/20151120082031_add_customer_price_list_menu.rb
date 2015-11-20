require File.expand_path('test/permission_helper')
include PermissionHelper

class AddCustomerPriceListMenu < ActiveRecord::Migration
  def up
    PermissionHelper.add_item(
      program: 'Asiakkaat',
      name: 'Asiakashinnasto',
      uri: 'pupenext/customer_price_lists'
    )
  end

  def down
    PermissionHelper.remove_all(
      uri: 'pupenext/customer_price_lists'
    )
  end
end
