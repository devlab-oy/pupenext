module QrCode
  class << self
    def generate(string, path = "/tmp/qr-code-#{SecureRandom.uuid}.png")
      path if %x(qrencode -o #{path} "#{string}")
    end
  end
end
