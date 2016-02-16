require File.expand_path('test/permission_helper')
include PermissionHelper

class CommodityPermissions < ActiveRecord::Migration
  def up
    PermissionHelper.add_item(
      program: 'Kirjanpito',
      name: 'Käyttöomaisuuden hyödykkeet',
      uri: 'pupenext/commodities'
    )
  end

  def down
    PermissionHelper.remove_all(
      uri: 'pupenext/commodities'
    )
  end
end
