module QrCode
  class << self
    def generate(string, filename)
      %x(qrencode -o #{filename} "#{string}")
    end
  end
end
