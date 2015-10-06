class Import::ProductKeyword
  def initialize(filename)
    @file = setup_file filename
  end

  private

    def setup_file(filename)
      file = File.open filename.to_s
      Roo::Spreadsheet.open file
    ensure
      file.close if file
    end
end
