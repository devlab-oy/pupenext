class AddUlkoinenJarjestelmaTimestamp < ActiveRecord::Migration
  def change
    add_column :lasku, :lahetetty_ulkoiseen_varastoon, :datetime, after: :piiri
  end
end
