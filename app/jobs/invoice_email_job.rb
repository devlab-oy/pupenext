require 'fileutils'

class InvoiceEmailJob < ActiveJob::Base
  attr_accessor :incoming_mail, :message
  queue_as :invoice_email

  def perform(id:)
    self.incoming_mail = IncomingMail.find(id)
    self.message = Mail.new incoming_mail.raw_source

    Current.company = incoming_mail.company
    Current.user = Current.company.users.find_by! kuka: :admin

    process_message
  end

  private

    def process_message
      return unless message_valid?

      # käsitellään kaikki viestin liitetiedostot, palautuu array status_messageita
      status_messages = process_attachments

      incoming_mail.update!(
        processed_at: Time.zone.now,
        status: :ok,
        status_message: status_messages.join("\n"),
      )
    end

    def from_address
      return '' unless message.from.respond_to? :first

      message.from.first.to_s.downcase
    end

    def to_address
      return '' unless message.to.respond_to? :first

      message.to.first.to_s.split('@').first || ''
    end

    def language
      return :fi if from_address.end_with?('.fi')

      :en
    end

    def attach_dir
      root = Rails.application.secrets.pupesoft_install_dir
      path = incoming_mail.company.parameter.skannatut_laskut_polku
      save_dir = "#{root}/#{path}"

      if to_address.include? '+'
        user = to_address.split('+').last

        return "#{save_dir}/matkalaskut/#{user}"
      end

      save_dir
    end

    def from_domain_allowed?
      # envissä voidaan määritellä sallitut domainit välilyönnillä eroteltuna, muuten kaikki on sallittu
      allowed_domains = Rails.application.secrets.invoice_mail_allowed_domains.to_s

      allowed_domains.empty? || allowed_domains.split.any? { |a| from_address.end_with? a }
    end

    def message_valid?
      return error("Lähettäjän domain ei ole sallittu: #{from_address}") unless from_domain_allowed?
      return error('Viestissä ei ollut liitetiedostoja') if message.attachments.empty?
      return error("Hakemistoa ei löydy: #{attach_dir}") unless File.directory?(attach_dir)

      true
    end

    def process_attachments
      message.attachments.map do |file|
        if process_file(file)
          "Liitetiedosto käsitelty: #{file.filename}"
        else
          "Virheellinen liitetiedostomuoto: #{file.filename} (#{file.content_type})"
        end
      end
    end

    def process_file(file)
      # only process images and pdfs
      return false unless file.content_type.start_with?('image/', 'application/pdf')

      # Prefix with random string
      prefix = SecureRandom.hex(15)
      safe_filename = file.filename.downcase.gsub(/[^a-z0-9\.\-]/, '').squeeze('.')

      # Save file
      begin
        f = File.open "#{attach_dir}/#{prefix}-#{safe_filename}", 'w+b'
        f.write file.body.decoded
        f.close
      rescue
        return false
      end

      true
    end

    def error(message)
      incoming_mail.update!(
        processed_at: Time.zone.now,
        status: :error,
        status_message: message,
      )

      false
    end
end
