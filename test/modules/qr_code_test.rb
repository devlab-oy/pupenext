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

  test "generate takes optional size as parameter" do
    test_string = "I am a testing string"
    file1 = QrCode.generate(test_string)
    file2 = QrCode.generate(test_string, size: 10)

    assert_not_equal File.size(file1), File.size(file2)
  end
end
