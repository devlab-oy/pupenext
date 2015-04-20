require "test_helper"

class QrCodeTest < ActiveSupport::TestCase
  test "generate generates QR code from a string and saves it to specified file" do
    QrCode.generate("Lorem ipsum dolor sit amet, consectetur adipiscing elit.", path: "/tmp/qrcode")

    assert File.exists?("/tmp/qrcode.png")
  end

  test "generate handles jpg format properly" do
    QrCode.generate("Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                    path: "/tmp/qrcode", format: "jpg")

    assert File.exists?("/tmp/qrcode.jpg")
  end
end
