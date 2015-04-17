require "test_helper"

class QrCodeTest < ActiveSupport::TestCase
  test "generate generates QR code from a string and saves it to specified file" do
    QrCode.generate("Lorem ipsum dolor sit amet, consectetur adipiscing elit.", "/tmp/qrcode.png")

    assert File.exists?("/tmp/qrcode.png")
  end
end
