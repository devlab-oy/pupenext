class HuutokauppaJob < ActiveJob::Base
  queue_as :huutokauppa

  def perform(id:)
    @incoming_mail = IncomingMail.find(id)

    Current.company = @incoming_mail.company
    Current.user    = Current.company.users.find_by!(kuka: 'admin')

    @huutokauppa_mail = HuutokauppaMail.new(@incoming_mail.raw_source)

    case @huutokauppa_mail.type
    when :offer_accepted, :offer_automatically_accepted
      update_order_customer_and_product_info
    when :purchase_price_paid
      mark_order_as_done_and_set_delivery_method
    when :delivery_ordered
      update_order_delivery_info_and_delivery_method
    end
  end

  private

    def update_order_customer_and_product_info
      customer = @huutokauppa_mail.find_customer || @huutokauppa_mail.create_customer

      @huutokauppa_mail.update_order_customer_info
      @huutokauppa_mail.update_order_product_info

      @incoming_mail.update!(
        processed_at: Time.now,
        status: :ok,
      )
    rescue => e
      log_error(e)
    end

    def mark_order_as_done_and_set_delivery_method
      @huutokauppa_mail.update_delivery_method_to_nouto
      @huutokauppa_mail.add_delivery_row
      @huutokauppa_mail.find_draft.mark_as_done
    rescue => e
      log_error(e)
    end

    def update_order_delivery_info_and_delivery_method
      @huutokauppa_mail.update_order_delivery_info
      @huutokauppa_mail.find_order.update!(delivery_method: DeliveryMethod.find_by!(selite: 'Itella Economy 16'))
    rescue => e
      log_error(e)
    end

    def log_error(exception)
      @incoming_mail.update!(
        processed_at: Time.now,
        status: :error,
        status_message: exception.message,
      )
    end
end
