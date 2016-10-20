class Woo::Orders < Woo::Base
  ORDERS_PATH = "/tmp/orders/"

  def fetch
    # Fetch orders from woocommerce
    woocommerce_orders = @woocommerce.get("orders", {status: 'any'}).parsed_response
    # Create edi orders
    write_to_file(woocommerce_orders)
  end

  def write_to_file(orders)
    orders.each do |order|
      File.open(File.join(ORDERS_PATH, "order_#{order["id"]}.txt"), "w") do |file|
        file.write(build_edi_order(order))
      end
    end
  end

  def build_edi_order(order)
    ApplicationController.new.render_to_string 'data_import/edi_order',
      layout: false, locals: {:@order => order}
  end
end
