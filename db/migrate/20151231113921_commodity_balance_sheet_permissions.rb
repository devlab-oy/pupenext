require File.expand_path('test/permission_helper')
include PermissionHelper

class CommodityBalanceSheetPermissions < ActiveRecord::Migration
  def up
    PermissionHelper.add_item(
      program: 'Kirjanpitoraportit',
      name: 'Hyödykkeiden tase-erittely',
      uri: 'pupenext/commodity_balance_sheet'
    )
  end

  def down
    PermissionHelper.remove_all(
      uri: 'pupenext/commodity_balance_sheet'
    )
  end
end
