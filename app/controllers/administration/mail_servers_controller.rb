class Administration::MailServersController < AdministrationController
  def index
    @mail_servers = MailServer.all
  end
end
