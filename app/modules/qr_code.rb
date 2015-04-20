module QrCode
  class << self
    def generate(string, options = {})
      path = options[:path] ? options[:path] : "/tmp/qr-code-#{SecureRandom.uuid}"
      format = options[:format] ? options[:format] : "png"

      if format == "png"
        "#{path}.png" if %x(qrencode -o #{path}.png "#{string}")
      else
        %x(qrencode -o #{path}.png "#{string}")
        "#{path}.jpg" if %x(convert #{path}.png #{path}.jpg)
      end
    end
  end
end
