require File.expand_path('test/permission_helper')
include PermissionHelper

class AddPermissionsToStockListingConfigurableCsv < ActiveRecord::Migration
  def up
    PermissionHelper.add_item(
      program: 'Varastoraportit',
      name: 'Varastosaldot FIN CSV',
      uri: 'pupenext/stock_listing_configurable_csv',
    )
  end

  def down
    PermissionHelper.remove_all uri: 'pupenext/stock_listing_configurable_csv'
  end
end
