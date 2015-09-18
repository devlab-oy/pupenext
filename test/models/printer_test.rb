require 'test_helper'

class PrinterTest < ActiveSupport::TestCase
  fixtures %w(printers)

  setup do
    @printer1 = printers(:printer1)
    @printer2 = printers(:printer2)
  end

  test 'all valid' do
    assert @printer1.valid?, @printer1.errors.messages
    assert @printer2.valid?, @printer2.errors.messages
  end

  test 'komento' do
    @printer1.komento = '   '
    refute @printer1.valid?

    @printer1.komento = 'lpr'
    refute @printer1.valid?
  end

  test "komento can't include forbidden characters" do
    forbidden_chars = %w(" ' < > \\ ;)

    forbidden_chars.each do |char|
      @printer1.komento = "lpr #{char}"
      refute @printer1.valid?
      refute @printer1.save
    end
  end

  test "komento needs to be unique in company" do
    @printer2.komento = @printer1.komento
    refute @printer2.valid?

    @printer2.yhtio = 'esto'
    assert @printer2.valid?
  end

  test 'kirjoitin' do
    @printer1.kirjoitin = '   '
    refute @printer1.valid?
  end

  test 'merkisto' do
    merkistot = {
      "charset_default"     => 0,
      "charset_7bit"        => 1,
      "charset_dos"         => 2,
      "charset_ansi"        => 3,
      "charset_utf8"        => 4,
      "charset_scandic_off" => 5
    }
    assert_equal merkistot, @printer1.class.merkistos
  end

  test 'mediatyyppi' do
    mediatyyppit = {
      "media_default"  => "",
      "media_a4"       => "A4",
      "media_a5"       => "A5",
      "media_thermal1" => "LSN149X104",
      "media_thermal2" => "LSN59X40",
      "media_thermal3" => "LS149X104",
      "media_thermal4" => "LS59X40",
      "media_receipt"  => "kuittitulostin"
    }
    assert_equal mediatyyppit, @printer1.class.mediatyyppis
  end

end
