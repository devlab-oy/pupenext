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
end
