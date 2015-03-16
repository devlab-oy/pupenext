require 'test_helper'

class PrinterTest < ActiveSupport::TestCase

  def setup
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

    @printer2.yhtio = "kala"
    assert @printer2.valid?
  end

  test 'kirjoitin' do
    @printer1.kirjoitin = '   '
    refute @printer1.valid?
  end

  test 'merkisto' do
    @printer1.merkisto = 100
    refute @printer1.valid?
  end

  test 'mediatyyppi' do
    @printer1.mediatyyppi = 'invalid'
    refute @printer1.valid?
  end

end
