class DataImportController < ApplicationController
  def index
  end

  def products
    if @spreadsheet = uploaded_spreadsheet
      render :results
    else
      flash[:error] = 'Invalid file!'
      redirect_to data_import_path
    end
  end

  private

    def uploaded_spreadsheet
      uploaded_io = params[:file]

      return unless uploaded_io

      extension = File.extname uploaded_io.original_filename
      file_path = Tempfile.new ['data_import', ".#{extension}"]

      begin
        File.open(file_path, 'wb') { |file| file.write uploaded_io.read }

        Roo::Spreadsheet.open file_path.path
      rescue => e
        false
      ensure
        file_path.close
        file_path.unlink
      end
    end
end
