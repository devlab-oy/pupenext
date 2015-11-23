require File.expand_path('test/permission_helper')
include PermissionHelper

class AddOnlineStoresMenu < ActiveRecord::Migration
  def up
    PermissionHelper.add_item(
      program: 'Tuotehallinta',
      name:    'Verkkokaupat',
      uri:     'pupenext/online_stores'
    )
  end

  def down
    PermissionHelper.remove_all(
      uri: 'pupenext/online_stores'
    )
  end
end
