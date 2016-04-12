class IncomingMailJob < ActiveJob::Base
  queue_as :default

  def perform(mailbox_prefix: 'INBOX.', protocol: :imap, port: 993, enable_ssl: true)
    MailServer.all.each do |mail_server|
      process_dir = "#{mailbox_prefix}#{mail_server.process_dir}"
      done_dir    = "#{mailbox_prefix}#{mail_server.done_dir}"

      Mail.defaults do
        retriever_method protocol, address:    mail_server.imap_server,
                                   port:       port,
                                   user_name:  mail_server.imap_username,
                                   password:   mail_server.imap_password,
                                   enable_ssl: enable_ssl
      end

      Mail.find(mailbox: process_dir) do |message, connection, message_uid|
        incoming_mail = mail_server.incoming_mails.create(raw_source: message.raw_source)

        "#{mail_server.processing_type}Job".constantize.perform_later(id: incoming_mail.id)

        connection.uid_move(message_uid, done_dir)
      end
    end
  end
end
