class DirectDebitNumberInvoice < ActiveRecord::Migration
  def change
    add_column :lasku, :directdebitsiirtonumero, :integer, default: 0, null: false, after: :factoringsiirtonumero
  end
end
