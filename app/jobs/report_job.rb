class ReportJob < ActiveJob::Base
  # To use this worker, report class instance must implement a "to_file" method
  # that runs the report, saves the result to a file, and returns a string with a full
  # path to the created file.

  queue_as :reports

  def perform(user_id:, report_class:, report_params:, report_name:)
    user = User.find user_id
    Current.company = user.company

    # Run the report
    filename = report_class.constantize.new(report_params).to_file

    # Save the resulting file to user's downloads list
    download = user.downloads.create! report_name: report_name
    download.files.create! filename: filename, data: File.read(filename)

    # Remove file
    File.delete(filename)
  end
end
