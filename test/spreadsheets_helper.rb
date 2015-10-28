module SpreadsheetsHelper

  private

    # Creates an Roo::Spreadsheet out of response.body
    # Returns the first sheet of spreadsheet
    def open_excel(response)
      filename = Tempfile.new('spreadsheet').path
      File.open(filename, 'wb') { |file| file.write(response) }

      xlsx = Roo::Spreadsheet.open(filename, extension: :xlsx)

      File.delete(filename)

      xlsx.sheet(0)
    end

    # Creates an xlsx file out of an array
    # Returns full path of the created file
    def create_xlsx(array)
      file = Tempfile.new(['example', '.xlsx'])
      filename = file.path
      file.unlink
      file.close

      Axlsx::Package.new do |p|
        p.workbook.add_worksheet(name: "Sheet") do |sheet|
          array.each { |row| sheet.add_row row }
        end
        p.serialize filename
      end

      filename
    end
end
