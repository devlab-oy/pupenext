class Woo::Orders < Woo::Base
  EDI_ORDERS_PATH = 'tmp/orders/'

  # Fetch new WooCommerce orders and set status to processing
  def fetch
    # Fetch orders from woocommerce
    response = @woocommerce.get("orders", {status: 'any'})

    if response.success?
      response.parsed_response.each do |order|
        # update orders status to 'fetched'
        if @woocommerce.put("orders/#{order['id']}", {status: 'processing'}).success?
          write_to_file(order, EDI_ORDERS_PATH)
        else
          logger.error "error in updating order status"
        end
      end
    else
      logger.error "error in fetching orders"
    end
  end

  # Set WooCommerce order status to complete
  def complete_order(order_number)
    order = @woocommerce.get("orders/#{order_number}").parsed_response
    if @woocommerce.put("orders/#{order['id']}", {status: 'completed'} ).success?
      # TODO: Tracking code as order note
      # woocommerce.post("orders/#{order_number}/notes", {note: tracking_code, customer_note: true}).parsed_response
      logger.info "Order #{order['id']} status set to completed"
    else
      logger.error "Error in completing order #{order['id']}"
    end
  end

  def write_to_file(order, path)
    File.open(File.join(path, "order_#{order["id"]}.txt"), "w") do |file|
      file.write(build_edi_order(order))
    end
  end

  def build_edi_order(order)
    ApplicationController.new.render_to_string 'data_import/edi_order',
      layout: false, locals: {:@order => order}
  end
end
