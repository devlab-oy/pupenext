# common functionality for import classes
module Import::Base

  private

    def spreadsheet
      @spreadsheet ||= @file.sheet(0)
    end

    def header_row
      @header_row ||= spreadsheet.row(1)
    end

    def row_to_hash(array)
      hash = {}

      array.each_with_index  do |value, index|
        key = header_row[index].to_s.downcase

        hash[key] = value
      end

      hash
    end

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
