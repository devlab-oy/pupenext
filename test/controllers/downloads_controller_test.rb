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
    login users(:joe)
    get :show, id: @file.id
    assert_response :success
  end

  test 'should not be able to download other users file' do
    # this is joes file, should raise exception
    assert_raises { get :show, id: @file.id }
  end
end
