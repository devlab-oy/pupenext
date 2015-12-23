require File.expand_path('test/permission_helper')
include PermissionHelper

class AddCustomerTransportsPermissions < ActiveRecord::Migration
  def up
    PermissionHelper.add_item(
      program: 'Ylläpito',
      name: 'Asiakkaiden tiedonsiirtoyhteydet',
      uri: 'pupenext/customer_transports'
    )
  end

  def down
    PermissionHelper.remove_all(
      uri: 'pupenext/customer_transports'
    )
  end
end
