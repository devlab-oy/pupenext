class HuutokauppaJob < ActiveJob::Base
  queue_as :huutokauppa

  def perform(id:)
    incoming_mail = IncomingMail.find(id)

    Current.company = incoming_mail.company
    Current.user    = Current.company.users.find_by!(kuka: 'admin')

    incoming_mail.update(
      processed_at: Time.now,
      status: :ok
    )
  end
end
