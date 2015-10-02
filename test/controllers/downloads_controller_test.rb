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
    @download = download_downloads(:one)
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

  test 'deleting download should delete all files aswell' do
    login users(:joe)

    assert_difference(['Download::Download.count', 'Download::File.count'], -1)  do
      delete :destroy, id: @download.id
    end

    assert_redirected_to downloads_path
  end
end
