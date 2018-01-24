class AddPurchaseInvoiceAccountnumberParameter < ActiveRecord::Migration
  def up
    add_column :yhtion_parametrit, :ostolaskujen_oletusiban, :string, limit: 1, default: '', null: false, after: :ostolaskujen_oletusvaluutta
  end

  def down
    remove_column :yhtion_parametrit, :ostolaskujen_oletusiban
  end
end
