require "test_helper"
require "json_helper"

class QrCodesControllerTest < ActionController::TestCase
  include JsonHelper

  setup do
    login users(:joe)
  end

  test "accessing generate with a string generates a qr code and returns the path" do
    get :generate, { string: "Lorem ipsum" }

    assert_response :success
    assert File.exists?(json[:filename])
  end

  test "accessing generate with format jpg generates jpg image" do
    get :generate, { string: "Lorem ipsum", format: "jpg" }

    assert_response :success
    assert_equal "jpg", json[:filename].split(".").last
    assert File.exists?(json[:filename])
  end
end
