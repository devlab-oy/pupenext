require 'test_helper'

class PrinterTest < ActiveSupport::TestCase

  def setup
    @printer1 = printers(:printer1)
    @printer2 = printers(:printer2)
  end

  test 'all valid' do
    assert(@printer1.valid?)
    assert(@printer2.valid?)
  end

  test 'komento' do
    @printer1.komento = '   '
    refute @printer1.valid?

    @printer1.komento = 'lpr'
    refute @printer1.valid?
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
