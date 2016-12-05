require File.expand_path('test/permission_helper')
include PermissionHelper

class AddPrestauiPermissions < ActiveRecord::Migration
  def up
    PermissionHelper.add_item(
      program: 'Ylläpito',
      name: 'PrestaShop ajot',
      uri: 'rajapinnat/presta/presta_kayttoliittyma.php',
    )
  end

  def down
    PermissionHelper.remove_all uri: 'rajapinnat/presta/presta_kayttoliittyma.php'
  end
end
