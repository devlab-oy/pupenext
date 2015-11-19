class FinvoiceVersionParam < ActiveRecord::Migration
  def up
    add_column :yhtion_parametrit, :finvoice_versio, :string, limit: 1, default: '', null: false, after: :verkkolasku_lah
  end

  def down
    remove_column :yhtion_parametrit, :finvoice_versio
  end
end
