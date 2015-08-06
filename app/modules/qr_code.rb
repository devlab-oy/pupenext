module QrCode
  def self.generate(string, options = {})
    path   = options[:path]   ? options[:path]   : "/tmp/qr-code-#{SecureRandom.uuid}"
    format = options[:format] ? options[:format] : "png"
    size   = options[:size]   ? options[:size]   : false
    height = options[:height] ? options[:height] : false

    arguments = %W(-o #{path}.png)
    arguments += %W(-s #{size}) if size
    arguments << string

    system("qrencode", *arguments)

    if height || format != "png"
      arguments = %W(#{path}.png)
      arguments += %W(-resize x#{height}) if height
      arguments << "#{path}.#{format}"

      system("convert", *arguments)
    end

    "#{path}.#{format}"
  end
end
