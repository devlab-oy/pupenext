class AddColumnsToMessenger < ActiveRecord::Migration
  def up
    add_column :messenger, :ryhma, :char, default: '', null: false, after: :vastaanottaja
  end

  def down
    remove_column :messenger, :ryhma
  end
end
