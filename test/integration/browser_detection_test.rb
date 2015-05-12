require 'test_helper'

class BrowserDetectionTest < ActionDispatch::IntegrationTest
  include LoginHelper

  test "browsers are detected correctly" do
    bob = users(:bob)

    bob.update(kayttoliittyma: "U")
    login users(:bob)

    { "Firefox" => "pupesoft_mozilla.css",
      "Trident Windows" => "pupesoft_ms_ie.css",
      "Chrome Windows" => "pupesoft_ms_chrome.css" }.each do |browser, css_file|

      get "/accounts", {}, { "User-Agent" => browser }

      assert_includes(response.body, css_file)
    end
  end
end
