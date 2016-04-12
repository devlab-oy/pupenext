class Administration::IncomingMailsController < ApplicationController
  def index
    @incoming_mails = IncomingMail.all
  end
end
