PDFKit.configure do |config|
  options = [
    '/usr/bin/wkhtmltopdf',
    '/usr/local/bin/wkhtmltopdf'
  ].each do |dir|
    if File.exists?(dir)
      config.wkhtmltopdf = dir
    end
  end
end
