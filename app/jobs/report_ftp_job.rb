class ReportFtpJob < ActiveJob::Base
  # To use this worker, report class instance must implement a "to_file" method
  # that runs the report, saves the result to a file, and returns a string with a full
  # path to the created file.

  queue_as :reports

  def perform(transport_id:, report_class:, report_params:)
    # Fetch transport
    transport = Transport.find transport_id

    # Run the report
    filename = report_class.constantize.new(report_params).to_file

    # Send the file
    FtpSendJob.perform_later(transport_id: transport_id, file: filename)
  end
end
