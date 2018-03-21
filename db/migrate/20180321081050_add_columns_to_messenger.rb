class AddColumnsToMessenger < ActiveRecord::Migration
  def up
    add_column :messenger, :ryhma, :string, limit: 50, default: '', null: false, after: :vastaanottaja
  end

  def down
    remove_column :messenger, :ryhma
  end
end
