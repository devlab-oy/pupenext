class UpdateH1timeDateToLasku < ActiveRecord::Migration
  def up
    Company.find_each do |company|
      Current.company = company.yhtio

      purchase_orders = PurchaseOrder::Order.where(alatila: %w(A X))

      purchase_orders.find_each do |po|
        h1time = po.lahetepvm ? po.lahetepvm : po.luontiaika
        hyvak1 = po.laatija
        po.update!(h1time: h1time, hyvak1: hyvak1)
      end
    end
  end

  def down
    Company.find_each do |company|
      Current.company = company.yhtio

      purchase_orders = PurchaseOrder::Order.where(alatila: %w(A X))

      purchase_orders.find_each do |po|
        po.update!(h1time: '0000-00-00 00:00:00', hyvak1: '')
      end
    end
  end
end
