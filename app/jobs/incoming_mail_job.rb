class IncomingMailJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    MailServer.all.each do |mail_server|
      Mail.defaults do
        retriever_method :imap, address:    mail_server.imap_server,
                                port:       993,
                                user_name:  mail_server.imap_username,
                                password:   mail_server.imap_password,
                                enable_ssl: true
      end

      Mail.find(mailbox: "INBOX.#{mail_server.process_dir}") do |message, connection, message_uid|
        mail_server.incoming_mails.create(raw_source: message.raw_source)

        connection.uid_move(message_uid, "INBOX.#{mail_server.done_dir}")
      end
    end
  end
end
