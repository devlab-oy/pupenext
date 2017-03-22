class FixPermissions < ActiveRecord::Migration
  def up
    Permission.unscoped.where("profiili != '' and kuka!='' and profiili!=kuka")
      .update_all("profiili=''")
  end
end
