require 'tempfile'

class FileEncodingConverter
  def initialize(filename:, encoding:)
    raise ArgumentError unless Encoding.list.map(&:to_s).include? encoding

    @filename = filename
    @encoding = encoding
  end

  def convert
    # ruby is always utf8, no need to do anything if utf8 requested
    return true if @encoding == 'UTF-8'

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
      File.read(@filename).encode(@encoding, {
        invalid: :replace,
        undef:   :replace,
        replace: '?'
      })
    end
end
