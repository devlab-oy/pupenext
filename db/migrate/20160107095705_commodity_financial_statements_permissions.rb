require File.expand_path('test/permission_helper')
include PermissionHelper

class CommodityFinancialStatementsPermissions < ActiveRecord::Migration
  def up
    PermissionHelper.add_item(
      program: 'Kirjanpitoraportit',
      name: 'Hyödykkeiden tilinpäätöstiedot',
      uri: 'pupenext/commodity_financial_statements'
    )
  end

  def down
    PermissionHelper.remove_all(
      uri: 'pupenext/commodity_financial_statements'
    )
  end
end
