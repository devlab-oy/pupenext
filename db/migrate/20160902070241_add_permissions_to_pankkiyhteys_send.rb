require File.expand_path('test/permission_helper')
include PermissionHelper

class AddPermissionsToPankkiyhteysSend < ActiveRecord::Migration
  def up
    PermissionHelper.add_item(
      program: 'Kirjanpito',
      name: 'Lähetä aineistoja pankkiin',
      uri: 'pankkiyhteys.php',
      suburi: 'laheta',
    )
  end

  def down
    PermissionHelper.remove_all(
      uri: 'pankkiyhteys.php',
      suburi: 'laheta',
    )
  end
end
