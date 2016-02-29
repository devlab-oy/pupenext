class ModifyCompanyEanColumn < ActiveRecord::Migration
  def change
    change_column :yhtio, :ean, :integer, default: 0, null: false
  end
end
