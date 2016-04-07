class Administration::MailServersController < AdministrationController
  def index
    @mail_servers = MailServer.all
  end

  def new
    @mail_server = MailServer.new
  end

  private

    def find_resource
      @mail_server ||= MailServer.find(params[:id])
    end
end
