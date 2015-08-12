require 'test_helper'

class PrinterHelperTest < ActionView::TestCase
  test "returns translated merkisto options valid for collection" do
    assert merkisto_options.is_a? Array

    text = I18n.t 'administration.printers.merkisto_options.charset_default', :fi
    assert_equal text, merkisto_options.first.first
    assert_equal 'charset_default', merkisto_options.first.second
  end

  test "returns translated mediatyyppi options valid for collection" do
    assert mediatyyppi_options.is_a? Array

    text = I18n.t 'administration.printers.mediatyyppi_options.media_default', :fi
    assert_equal text, mediatyyppi_options.first.first
    assert_equal 'media_default', mediatyyppi_options.first.second
  end
end
