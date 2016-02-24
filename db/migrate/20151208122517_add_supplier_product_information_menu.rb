require File.expand_path('test/permission_helper')
include PermissionHelper

class AddSupplierProductInformationMenu < ActiveRecord::Migration
  def up
    PermissionHelper.add_item(
      program: 'Tuotehallinta',
      name: 'Toimittajien tuotetiedot',
      uri: 'pupenext/supplier_product_informations'
    )
  end

  def down
    PermissionHelper.remove_all(
      uri: 'pupenext/supplier_product_informations'
    )
  end
end
