class IncomingMailJob < ActiveJob::Base
  queue_as :incoming_mail

  def perform
    MailServer.all.each do |mail_server|
      Mail.defaults do
        retriever_method :imap, address:    mail_server.imap_server,
                                port:       993,
                                user_name:  mail_server.imap_username,
                                password:   mail_server.imap_password,
                                enable_ssl: true
      end

      Mail.find(mailbox: mail_server.process_dir) do |message, connection, message_uid|
        # TODO: When Ruby has been updated to version 2.3, these 4 lines can be replaced by
        # connection.uid_move(message_uid, mail_server.done_dir)
        connection.uid_copy(message_uid, mail_server.done_dir)
        connection.select(mail_server.process_dir)
        connection.uid_store(message_uid, '+FLAGS', [:Deleted])
        connection.expunge

        # save message source to db
        incoming_mail = mail_server.incoming_mails.create!(raw_source: message.raw_source)

        # process message
        "#{mail_server.processing_type}Job".constantize.perform_later(id: incoming_mail.id)
      end
    end
  end
end
