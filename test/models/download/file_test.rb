require 'test_helper'

class Download::FileTest < ActiveSupport::TestCase
  fixtures %w(
    download/downloads
    download/files
  )

  setup do
    @one = download_files :one
  end

  test 'fixtures are valid' do
    assert @one.valid?
  end

  test 'relations' do
    assert_equal "Sales report", @one.download.report_name
  end
end
