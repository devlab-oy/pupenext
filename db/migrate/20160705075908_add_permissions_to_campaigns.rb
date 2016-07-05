require File.expand_path('test/permission_helper')
include PermissionHelper

class AddPermissionsToCampaigns < ActiveRecord::Migration
  def up
    PermissionHelper.add_item(
      program: 'Tuotehallinta',
      name: 'Kampanjat',
      uri: 'pupenext/campaigns',
    )
  end

  def down
    PermissionHelper.remove_all(
      uri: 'pupenext/campaigns',
    )
  end
end
