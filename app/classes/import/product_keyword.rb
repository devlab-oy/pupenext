class Import::ProductKeyword
  def initialize(filename)
    @file = setup_file filename
  end

  def import
    true
  end

  private

    def setup_file(filename)
      # if we have an rails UploadedFile class
      if filename.respond_to?(:original_filename)
        file = filename.open
        extension = File.extname filename.original_filename
      else
        file = File.open filename.to_s
        extension = File.extname filename.to_s
      end

      Roo::Spreadsheet.open file, extension: extension
    ensure
      file.close if file
    end
end
