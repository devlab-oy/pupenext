class HuutokauppaJob < ActiveJob::Base
  queue_as :huutokauppa

  def perform(id:)
    incoming_mail = IncomingMail.find(id)

    incoming_mail.update(
      processed_at: Time.now,
      status: :ok
    )
  end
end
