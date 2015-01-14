class EmailWorker < ActiveJob::Base
  queue_as :PupeEmail

  def perform(params)
    # Params are inserted by php-resque into redis database and are of the following format
    #
    #[{"user"          => "somebody@example.com",
    #  "error_message" => "Sending failed to: somebody@example.com",
    #  "from"          => "no-reply@example.com",
    #  "from_name"     => "Somecompany Oy",
    #  "to"            => "somebody@example.com",
    #  "cc"            => "",
    #  "subject"       => "Somecompany Oy - Invoice 1812107",
    #  "body"          => "",
    #  "attachements"  => [
    #    {"filename"    => "/tmp/Lasku-adbce9b2d6403fa7e5ba71e2158ccc32.pdf",
    #     "newfilename" => "Lasku 1812107.pdf"
    #    }]
    #  }
    #]

    files = params['attachements'] ? params['attachements'] : []

    files.each do |file|
      filename = file['newfilename']
      filepath = file['filename']

      attachments[filename] = File.read(filepath)
    end

    from = %Q("#{params['from_name']}" <#{params['from']}>)

    begin
      mail(from: from,
           to: params['to'],
           subject: params['subject'],
           body: params['body']).deliver_now
    rescue => e
      # Notify user if mail sending failed
      body = "#{params['error_message']}\n\nERROR: #{e}\n\n#{params['body']}"

      mail(from: from,
           to: params['user'],
           subject: params['subject'],
           body: body).deliver_now
    end
  end
end
