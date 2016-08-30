class AddLivesearchMinimumToCompany < ActiveRecord::Migration
  def change
    add_column :yhtion_parametrit, :livetuotehaku_minimi, :tinyint, limit: 1, default: 3, null: false, after: :livetuotehaku_tilauksella
  end
end
