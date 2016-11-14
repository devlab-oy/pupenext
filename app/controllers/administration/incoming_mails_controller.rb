class Administration::IncomingMailsController < AdministrationController
  def index
    @incoming_mails = IncomingMail
      .paginate(page: params[:page], per_page: 200)
      .search_like(search_params).order(order_params)
  end

  private

    def sortable_columns
      [:mail_server_id, :processed_at, :status, :status_message]
    end

    def searchable_columns
      sortable_columns
    end
end
