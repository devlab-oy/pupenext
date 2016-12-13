require File.expand_path('test/permission_helper')
include PermissionHelper

class PermissionsToStockPerWarehouse < ActiveRecord::Migration
  def up
    PermissionHelper.add_item(
      program: 'Tuotehallinta',
      name: 'Saldokysely API',
      uri: 'pupenext/stock_available_per_warehouse',
      hidden: 'H',
    )
  end

  def down
    PermissionHelper.remove_all uri: 'pupenext/stock_available_per_warehouse'
  end
end
