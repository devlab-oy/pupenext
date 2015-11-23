class AddCompanyToOnlineStores < ActiveRecord::Migration
  def change
    add_reference :online_stores, :company, index: true, foreign_key: true
  end
end
