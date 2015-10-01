require 'test_helper'

class Download::DownloadTest < ActiveSupport::TestCase
  fixtures %w(
    download/downloads
    download/files
    users
  )

  setup do
    @one = download_downloads :one
  end

  test 'fixtures are valid' do
    assert @one.valid?
  end

  test 'relations' do
    assert @one.files.count > 0
    assert_equal "Joe Danger", @one.user.nimi
  end
end
