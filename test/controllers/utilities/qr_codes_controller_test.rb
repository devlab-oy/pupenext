require "test_helper"
require "json_helper"

class Utilities::QrCodesControllerTest < ActionController::TestCase
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

  test "accessing generate with size generates qr code of that size" do
    test_string = "A proper test string"
    get :generate, { string: test_string }

    size1 = File.size(json[:filename])

    get :generate, { string: test_string, size: 10 }

    size2 = File.size(json[:filename])

    assert_not_equal size1, size2
  end

  test "accessing generate with height generates qr code of that height" do
    test_string = "A proper test string"
    get :generate, { string: test_string }

    size1 = File.size(json[:filename])

    get :generate, { string: test_string, height: 225 }

    size2 = File.size(json[:filename])

    assert_not_equal size1, size2
  end
end
