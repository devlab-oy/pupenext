require 'net/ftp'

class FtpSendJob < ActiveJob::Base
  queue_as :ftp_send

  def perform(transport_id:, file:)
    raise "File '#{file}' not found" unless File.exist?(file)

    @transport = Transport.find transport_id
    @file = file

    send_file
  end

  private

    def send_file
      ftp = Net::FTP.new

      begin
        port = @transport.port || 21

        ftp.connect @transport.hostname, port
        ftp.login @transport.username, @transport.password
        ftp.chdir @transport.path if @transport.path.present?
        ftp.put @file
        ftp.quit
      rescue => e
        message = "FTP Error: #{e.message}"

        Rails.logger.error message

        raise message
      ensure
        ftp.close
      end
    end
end
