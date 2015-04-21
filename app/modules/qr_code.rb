module QrCode
  class << self
    def generate(string, options = {})
      path = options[:path] ? options[:path] : "/tmp/qr-code-#{SecureRandom.uuid}"
      format = options[:format] ? options[:format] : "png"
      size = options[:size] ? options[:size] : false
      height = options[:height] ? options[:height] : false

      command = "qrencode -o #{path}.png"
      command << " -s #{size}" if size
      command << " '#{string}'"

      %x(#{command})

      command = "convert #{path}.png"
      command << " -resize x#{height}" if height
      command << " #{path}.#{format}"

      %x(#{command})

      "#{path}.#{format}"
    end
  end
end
