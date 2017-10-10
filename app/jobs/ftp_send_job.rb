require 'net/ftp'

class FtpSendJob < ActiveJob::Base
  queue_as :ftp_send

  def perform(transport_id:, file:)
    raise "File '#{file}' not found" unless File.exist?(file)

    @transport = Transport.find transport_id
    @file = file

    convert_encoding
    send_file
  end

  private

    def send_file
      ftp = Net::FTP.new

      ftp.open_timeout = 5
      ftp.read_timeout = 30

      port = @transport.port || 21
      remotefile = @transport.filename || File.basename(@file)

      begin
        ftp.connect @transport.hostname, port
        ftp.login @transport.username, @transport.password
        ftp.passive = true
        ftp.chdir @transport.path

        # delete remote file if it exists
        ftp.delete remotefile if ftp.nlst.include?(remotefile)

        ftp.put @file, remotefile
        ftp.quit
      rescue => e
        message = "FTP Error: #{e.message}"

        Rails.logger.error message

        raise message
      ensure
        ftp.close
      end
    end

    def convert_encoding
      return unless @transport.encoding.to_s.length > 0

      FileEncodingConverter.new(filename: @file, encoding: @transport.encoding).convert
    end
end
