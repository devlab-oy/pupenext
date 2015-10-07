class Import::Response
  Row = Struct.new(:number, :columns, :errors)

  def initialize
    @number = 0
    @rows = []
    @headers = []
  end

  def add_headers(names:)
    @headers << names
  end

  def add_row(columns:, errors: nil)
    @number += 1
    @rows << Row.new(@number, columns, errors)
  end

  def headers
    @headers.flatten
  end

  def rows
    @rows
  end
end
