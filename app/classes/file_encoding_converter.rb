require 'tempfile'

class FileEncodingConverter
  def initialize(filename:, encoding:, read_encoding: 'UTF-8')
    raise ArgumentError, 'invalid encoding' unless supported_encodings.include? encoding
    raise ArgumentError, 'invalid read_encoding' unless supported_encodings.include? read_encoding
    raise ArgumentError, 'invalid file' unless File.writable? filename

    @filename = filename
    @encoding = encoding
    @read_encoding = read_encoding
  end

  def convert
    # write new file with correct encoding
    file = Tempfile.new 'convert', nil, encoding: @encoding
    file.write file_content
    file.close

    # Delete orginal file and rename temp as orginal
    File.delete @filename
    File.rename file.path, @filename

    true
  end

  private

    def file_content
      # read file, convert to encoding
      File.read(@filename, encoding: @read_encoding).encode(@encoding, {
        invalid: :replace,
        undef:   :replace,
        replace: '?'
      })
    end

    def supported_encodings
      Encoding.list.map &:to_s
    end
end
