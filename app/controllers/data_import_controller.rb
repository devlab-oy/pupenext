class DataImportController < ApplicationController
  def index
  end

  def products
    uploaded_io = params[:file]
    file_path = Rails.root.join 'tmp', uploaded_io.original_filename

    File.open(file_path, 'wb') do |file|
      file.write uploaded_io.read
    end

    redirect_to data_import_path
  end
end
