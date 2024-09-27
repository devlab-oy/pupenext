class Woo::Orders < Woo::Base
  attr_accessor :edi_orders_path, :customer_id, :order_status, :order_status_after

  # Fetch new WooCommerce orders and set status to processing
  def fetch(orders_path:, customer_id: nil, order_status: 'processing', order_status_after:)
    self.edi_orders_path = orders_path
    self.customer_id = customer_id
    self.order_status = order_status
    self.order_status_after = order_status_after

    # Fetch only order that are 'processing'
    response = woo_get('orders', status: order_status)

    logger.info "json: \n\n #{response.to_s}\n\n'"

    return unless response

    response.each do |order|
      # update orders status to 'on-hold'
      status = woo_put("orders/#{order['id']}", status: order_status_after)
      logger.info "Order #{order['id']} status set to #{order_status_after}"
      next unless status

      #changing the postnord_service_point_id to carrier_agent_id form metadata
      carrier_agent_id = order['meta_data'].select {|meta| meta["key"] == '_woo_carrier_agent_id'}
      unless carrier_agent_id.empty?
        order["shipping_lines"][0]["postnord_service_point_id"] = carrier_agent_id[0]["value"]
      end

      # Check if order already is in Pupesoft
      if customer_id == "b2b"
        @pupe_draft = SalesOrder::Draft.find_by(laatija: 'Harbour', asiakkaan_tilausnumero: order['id'])
        @pupe_order = SalesOrder::Order.find_by(laatija: 'Harbour', asiakkaan_tilausnumero: order['id'])
      elsif customer_id == "stock"
        @pupe_draft = SalesOrder::Draft.find_by(laatija: 'Stock', asiakkaan_tilausnumero: order['id'])
        @pupe_order = SalesOrder::Order.find_by(laatija: 'Stock', asiakkaan_tilausnumero: order['id'])
      else
        @pupe_draft = SalesOrder::Draft.find_by(laatija: 'WooCommerce', asiakkaan_tilausnumero: order['id'])
        @pupe_order = SalesOrder::Order.find_by(laatija: 'WooCommerce', asiakkaan_tilausnumero: order['id'])
      end

      if @pupe_draft.nil? && @pupe_order.nil?
        logger.info "Order #{order['id']} fetched and put in Pupesoft processing queue"
        write_to_file(order)
      else
        logger.info "Order #{order['id']} NOT fetched beacause it already exists in Pupesoft"
      end
    end
  end

  # Set WooCommerce order status to complete
  def complete_order(order_number, tracking_code = nil)
    # only update if order is 'on-hold'
    order = woo_get("orders/#{order_number}")
    logger.info "#{order}"
    return unless order
    return unless order['status'] == 'on-hold' || order['status'] == 'warehouse-process'

    logger.info "Order #{order['id']} status set to completed"
    return unless tracking_code.present?
  
    data = { meta_data: [
      {
       	key: "_tracking_code",
        value: tracking_code
      }
    ],
    }

    meta_reply =  woo_put("orders/#{order['id']}", data)
    status = woo_put("orders/#{order['id']}", status: 'completed')
    return unless status
    logger.info "Meta data #{meta_reply}"
    logger.info "Order #{order['id']} tracking code set to #{tracking_code}"
  end

  def write_to_file(order)
    logger.info "Writing EDI file"
    if customer_id == "b2b"
      filepath = File.join(edi_orders_path, "harbour-order-#{order['id']}.txt")
    elsif customer_id == "stock"
        filepath = File.join(edi_orders_path, "stock-order-#{order['id']}.txt")
    else
      filepath = File.join(edi_orders_path, "woo-order-#{order['id']}.txt")
    end

    #find the customer number from b2b customers
    logger.info "given customer_id: #{customer_id}"   
    case customer_id
    when "stock"
      logger.info "Going to stock branch! #{customer_id}"
      customer_id = Contact.where(rooli: "Woocommerce", ulkoinen_asiakasnumero: order['customer_id']).first.customer.asiakasnro
      order['status'] = "preorder"
      logger.info "stock customer: #{customer_id}"
      preorder =""
    when "b2b"
      logger.info "Going to b2b branch! #{customer_id}"
      customer_id = Contact.where(rooli: "Woocommerce", ulkoinen_asiakasnumero: order['customer_id']).first.customer.asiakasnro
      deliv_window = order['meta_data'].select {|meta| meta["key"] == '_delivery_window'}
      order['status'] = "preorder"
      unless deliv_window.empty?
        preorder = "Toimitusikkuna: " + deliv_window[0]["value"]
      else
        preorder =""
      end
      logger.info "b2b customer: #{customer_id}"
    else
      logger.info "going to else branch! with customer id #{customer_id}"
      preorder =""
      customer_id = "WEBSTORE"
    end

    logger.info "customer_id: #{customer_id}"
    File.open(filepath, 'w') do |file|
      file.write(build_edi_order(order, customer_id,preorder))
    end

    logger.info "Tallennettiin tilaus #{filepath}"
  end

  def build_edi_order(order, customer_id, preorder)
    locals = { :@company => Current.company, :@order => order, :@customer_id => customer_id, :@preorder => preorder}
    ApplicationController.new.render_to_string 'data_import/edi_order', layout: false, locals: locals
  end
end
