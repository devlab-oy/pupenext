module QrCode
  class << self
    def generate(string, options = {})
      path = options[:path] ? options[:path] : "/tmp/qr-code-#{SecureRandom.uuid}"
      format = options[:format] ? options[:format] : "png"
      size = options[:size] ? options[:size] : 3

      if format == "png"
        "#{path}.png" if %x(qrencode -o #{path}.png -s #{size} "#{string}")
      else
        %x(qrencode -o #{path}.png -s #{size} "#{string}")
        "#{path}.jpg" if %x(convert #{path}.png #{path}.jpg)
      end
    end
  end
end
