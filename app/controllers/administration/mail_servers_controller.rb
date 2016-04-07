class Administration::MailServersController < ApplicationController
  def index
    @mail_servers = MailServer.all
  end
end
