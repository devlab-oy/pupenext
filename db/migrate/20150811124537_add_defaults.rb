class AddDefaults < ActiveRecord::Migration
  def up
    change_column_default :asiakas, :koontilaskut_yhdistetaan, ''
    change_column_default :taso, :planned_depreciation_type, ''
    change_column_default :taso, :btl_depreciation_type, ''
  end

  def down
  end
end
