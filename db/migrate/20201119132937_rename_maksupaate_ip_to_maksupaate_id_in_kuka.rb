class RenameMaksupaateIpToMaksupaateIdInKuka < ActiveRecord::Migration
  def change
    rename_column :kuka, :maksupaate_ip, :maksupaate_id
  end
end
