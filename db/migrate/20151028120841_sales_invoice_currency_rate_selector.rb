class SalesInvoiceCurrencyRateSelector < ActiveRecord::Migration
  def up
    add_column :yhtion_parametrit, :myyntilaskujen_kurssipaiva, :tinyint, limit: 1, default: 0, null: false, after: :ostolaskujen_kurssipaiva
  end

  def down
    remove_column :yhtion_parametrit, :myyntilaskujen_kurssipaiva
  end
end
