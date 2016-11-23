namespace :woocommerce do
  desc "Fetch orders"

  task fetch_orders: :environment do
    orders = Woo::Orders.new.fetch
  end

  task create_products: :environment do
    Woo::Products.new.create
  end

  task update_products: :environment do
    Woo::Products.new.update
  end
end
