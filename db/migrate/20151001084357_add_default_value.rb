class AddDefaultValue < ActiveRecord::Migration
  def change
    change_column_default :pakkaus, :rahtivapaa_veloitus, ''
  end
end
