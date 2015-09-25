class AddDefaultsToOikeu < ActiveRecord::Migration
  def up
    change_column_default :oikeu, :kuka, ''
    change_column_default :oikeu, :laatija, ''
    change_column_default :oikeu, :muuttaja, ''
    change_column_default :oikeu, :nimitys, ''
  end

  def down
  end
end
