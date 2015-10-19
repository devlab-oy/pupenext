class ReportJob < ActiveJob::Base
  # To use this worker, report class instance must implement a "to_file" method
  # that runs the report, saves the result to a file, and returns a string with a full
  # path to the created file.

  queue_as :reports

  def perform(company_id:, user_id:, report_class:, report_params:, report_name:)
    # Fetch company
    company = Company.find company_id
    Current.company = company

    # Fetch user
    user = User.find user_id

    # Run the report
    filename = report_class.constantize.new(report_params).to_file

    if report_params[:binary]
      data = File.open(filename, 'rb') { |f| f.read }
    else
      data = File.read filename
    end

    # Save the resulting file to user's downloads list
    download = user.downloads.create! report_name: report_name
    download.files.create! filename: File.basename(filename), data: data

    # Remove file
    File.delete(filename)
  end
end
