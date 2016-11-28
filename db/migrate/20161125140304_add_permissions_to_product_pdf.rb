require File.expand_path('test/permission_helper')
include PermissionHelper

class AddPermissionsToProductPdf < ActiveRecord::Migration
  def up
    PermissionHelper.add_item(
      program: 'Tuotehallinta',
      name: 'Tuotteen hyllytarra',
      uri: 'pupenext/product_stock_pdf',
    )
  end

  def down
    PermissionHelper.remove_all uri: 'pupenext/product_stock_pdf'
  end
end
