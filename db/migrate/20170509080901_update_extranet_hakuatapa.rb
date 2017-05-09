class UpdateExtranetHakuatapa < ActiveRecord::Migration
  def up
    Parameter.unscoped.where("livetuotehaku_hakutapa_extranet = ''")
      .update_all("livetuotehaku_hakutapa_extranet=livetuotehaku_hakutapa")
  end
end

