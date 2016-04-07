class Administration::MailServersController < AdministrationController
  def index
    @mail_servers = MailServer.all
  end

  def new
    @mail_server = current_company.mail_servers.build
  end

  def create
    @mail_server = current_company.mail_servers.build(mail_server_params)

    if @mail_server.save
      redirect_to mail_servers_url
    else
      render :new
    end
  end

  def update
    if @mail_server.update(mail_server_params)
      redirect_to mail_servers_url
    else
      render :edit
    end
  end

  def destroy
    @mail_server.destroy!

    redirect_to mail_servers_url
  end

  private

    def find_resource
      @mail_server ||= MailServer.find(params[:id])
    end

    def mail_server_params
      params.require(:mail_server).permit(
        :imap_server,
        :imap_username,
        :imap_password,
        :smtp_server,
        :smtp_username,
        :smtp_password,
        :process_dir,
        :done_dir,
        :processing_type
      )
    end
end
