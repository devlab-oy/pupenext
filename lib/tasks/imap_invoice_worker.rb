require 'fileutils'
require 'mail'
require 'securerandom'

USERNAME          = ARGV[0]
PASSWORD          = ARGV[1]
IMAP_SERVER       = ARGV[2]
SMPT_SERVER       = ARGV[3]
ALLOWED_DOMAIN    = ARGV[4]
ARCHIVE_DIRECTORY = ARGV[5]
SAVE_DIRECTORY    = ARGV[6]
NOTIFY_EMAIL      = ARGV[7]

TRAVEL_DIRECTORY  = "matkalaskut"

EMAIL_REPLY_TEXT  = { fi: {
                        ok: "Liitetiedoston vastaanotto onnistui",
                        fail: "Liitetiedoston vastaanotto epäonnistui",
                        noattach: "Viestissä ei ollut liitetiedostoja",
                        nodir: "Matkalaskukansio puuttuu. Liitettä ei voitu tallentaa",
                        head: "Otsikko",
                        file: "Tiedosto"
                      },
                      en: {
                        ok: "Attached file received successfully",
                        fail: "Failed to receive attached file",
                        noattach: "Message did not contain attached files",
                        nodir: "Travel expense folder is missing. Attachment not saved",
                        head: "Title",
                        file: "File"
                      }
                    }

class ImapInvoiceWorker

  def self.fetch_messages
    # Make sure we have everything
    exit unless valid_parameters?

    # Set options
    Mail.defaults do
      retriever_method :imap, address: IMAP_SERVER,
                              port: 993,
                              user_name: USERNAME,
                              password: PASSWORD,
                              enable_ssl: true
      delivery_method :smtp,  address: SMPT_SERVER,
                              port: 587,
                              user_name: USERNAME,
                              password: PASSWORD,
                              enable_ssl: true
    end

    # Loop all messages in inbox
    Mail.all do |message, connector, item_uid|
      # Process message
      process_message(message)

      # Move message to Archive
      connector.uid_copy(item_uid, ARCHIVE_DIRECTORY)

      # Mark message deleted in inbox
      connector.select("INBOX")
      connector.uid_store(item_uid, "+FLAGS", [:Deleted])
    end
  end

  def self.process_message(msg)
    # Default directory for saving attachments
    attach_dir = SAVE_DIRECTORY.dup

    # Allow msgs only from allowed domain
    address = msg.from.first.downcase

    # Check the language for email reply
    lang = language(address)

    # Check "to"-address of mail
    toaddress = parse_to_address(msg)

    # This is a "Travel expense"-mail
    # We assume format of something.username@ALLOWED_DOMAIN
    if toaddress.include? "+"
      # Extract username
      te_user = toaddress.split('+').last

      # Check if userdir exists
      te_userdir = "#{SAVE_DIRECTORY}/#{TRAVEL_DIRECTORY}/#{te_user}"

      if File.directory? te_userdir
        attach_dir = te_userdir
      else
        # Send error message
        mail_options = {
          to: msg.from.first,
          from: USERNAME,
          subject: "#{EMAIL_REPLY_TEXT[lang][:fail]}",
          body: "#{EMAIL_REPLY_TEXT[lang][:head]}: #{msg.subject}\n" +
                "#{EMAIL_REPLY_TEXT[lang][:nodir]}",
        }

        send_email mail_options
      end
    end

    if ALLOWED_DOMAIN.empty? || ALLOWED_DOMAIN.split.any? { |a| address.end_with? a }

      # Loop all attachments
      msg.attachments.each { |file| handle_file(msg, file, lang, attach_dir) }

      if msg.attachments.empty?
        mail_options = {
          to: msg.from.first,
          bcc: NOTIFY_EMAIL,
          from: USERNAME,
          subject: "#{EMAIL_REPLY_TEXT[lang][:fail]}",
          body: "#{EMAIL_REPLY_TEXT[lang][:head]}: #{msg.subject}\n" +
                "#{EMAIL_REPLY_TEXT[lang][:noattach]}",
        }

        send_email mail_options
      end
    end
  end

  def self.handle_file(message, file, lang, attach_dir)
    # Get all images/pdfs from messages attachments
    if file.content_type.start_with?('image/', 'application/pdf')
      boob = save_image(file.filename, file.body.decoded, attach_dir)
    else
      boob = false
    end

    msg_status = boob ? :ok : :fail

    mail_options = {
      to: message.from.first,
      from: USERNAME,
      bcc: NOTIFY_EMAIL,
      subject: "#{EMAIL_REPLY_TEXT[lang][msg_status]}",
      body: "#{EMAIL_REPLY_TEXT[lang][:head]}: #{message.subject}\n" +
            "#{EMAIL_REPLY_TEXT[lang][:file]}: #{file.filename}",
      filename: file.filename,
      content: file.body.decoded
    }

    send_email mail_options
  end

  def self.save_image(name, data, attach_dir)
    # Prefix with random string
    prefix = SecureRandom.hex(15)

    # Filepath to SAVE_DIRECTORY
    attach_dir.sub!(/\/+$/, '')

    fname = "#{attach_dir}/#{prefix}-#{name.downcase.gsub(/[^a-z0-9\.\-]/, '').squeeze('.')}"

    # Save file
    begin
      f = File.open(fname, 'w+b')
      f.write data
      f.close
      true
    rescue Exception => e
      false
    end
  end

  # Send new email
  def self.send_email(options)
    mail = Mail.new do
      from options[:from]
      to options[:to]
      bcc options[:bcc]
      subject options[:subject]
      body options[:body]

      if options[:filename] && options[:content]
        add_file filename: options[:filename], content: options[:content]
      end
    end

    mail.charset = 'utf-8'
    mail.deliver
  end

  def self.language(email)
    return :fi if email.downcase.end_with?(".fi")
    :en
  end

  def self.valid_parameters?
    check = true
    check &= USERNAME
    check &= PASSWORD
    check &= IMAP_SERVER
    check &= SMPT_SERVER
    check &= ALLOWED_DOMAIN
    check &= ARCHIVE_DIRECTORY
    check &= SAVE_DIRECTORY
    check
  end

  def self.parse_to_address(msg)
    return '' unless msg.to.respond_to? :first

    msg.to.first.to_s.split('@').first || ''
  end
end

ImapInvoiceWorker.fetch_messages
