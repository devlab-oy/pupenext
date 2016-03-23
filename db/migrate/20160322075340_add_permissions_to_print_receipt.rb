require File.expand_path('test/permission_helper')
include PermissionHelper

class AddPermissionsToPrintReceipt < ActiveRecord::Migration
  def up
    PermissionHelper.add_item(
      program: 'Kirjanpitoraportit',
      name: 'Tulosta tiliotekuitti',
      uri: 'tilauskasittely/tulosta_tiliotekuitti.php',
      hidden: 'H'
    )
  end

  def down
    PermissionHelper.remove_all(
      uri: 'tilauskasittely/tulosta_tiliotekuitti.php'
    )
  end
end
