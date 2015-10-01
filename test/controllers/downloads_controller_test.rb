require 'test_helper'

class DownloadsControllerTest < ActionController::TestCase
  fixtures %w(
    download/downloads
    download/files
    users
  )

  setup do
    login users(:bob)
    @file = download_files :one
  end

  test 'get index' do
    get :index
    assert_response :success
  end

  test 'download file' do
    get :show, id: @file.id
    assert_response :success
  end
end
