class UpdateH1timeDateToLasku < ActiveRecord::Migration
  def up
    Company.find_each do |company|
      Current.company = company.yhtio

      PurchaseOrder::Order.where(alatila: %w(A X))
        .where("lasku.h1time = '0000-00-00 00:00:00'")
        .where("lasku.lahetepvm != '0000-00-00 00:00:00'")
        .update_all('lasku.h1time = lasku.lahetepvm, lasku.hyvak1 = lasku.laatija')

      PurchaseOrder::Order.where(alatila: %w(A X))
        .where("lasku.h1time = '0000-00-00 00:00:00'")
        .where("lasku.luontiaika != '0000-00-00 00:00:00'")
        .update_all('lasku.h1time = lasku.luontiaika, lasku.hyvak1 = lasku.laatija')
    end
  end

  def down
    Company.find_each do |company|
      Current.company = company.yhtio

      PurchaseOrder::Order.where(alatila: %w(A X))
        .update_all("lasku.h1time = '0000-00-00 00:00:00', lasku.hyvak1 = ''")
    end
  end
end
