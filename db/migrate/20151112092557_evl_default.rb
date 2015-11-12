class EvlDefault < ActiveRecord::Migration
  def change
    change_column_default :tili, :evl_taso, ''
  end
end
