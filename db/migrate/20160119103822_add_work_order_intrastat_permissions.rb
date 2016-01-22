require File.expand_path('test/permission_helper')
include PermissionHelper

class AddWorkOrderIntrastatPermissions < ActiveRecord::Migration
  def up
    PermissionHelper.add_item(
      program: 'Työmääräys',
      name: 'Työmääräyksen intrastat',
      uri: 'tyomaarays/tyomaarays_intrastat.php'
    )
  end

  def down
    PermissionHelper.remove_all(
      uri: 'tyomaarays/tyomaarays_intrastat.php'
    )
  end
end
