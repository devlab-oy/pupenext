class EmailWorkerJob < ActiveJob::Base
  queue_as :PupeEmail

  def perform(params)
    DefaultMailer.pupesoft_email(params).deliver_now
  end
end
