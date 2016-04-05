require 'test_helper'

class BrowserDetectionTest < ActionDispatch::IntegrationTest
  include LoginHelper

  setup do
    bob = users(:bob)

    bob.update(kayttoliittyma: "U")
    login users(:bob)
  end

  test "browsers are detected correctly" do
    tests = {
      "Chrome Windows"  => /pupesoft_ms_chrome-\S+\.css/,
      "Firefox Windows" => /pupesoft_ms_mozilla-\S+\.css/,
      "Firefox"         => /pupesoft_mozilla-\S+\.css/,
      "Trident Windows" => /pupesoft_ms_ie-\S+\.css/,
    }

    tests.each do |browser, css_file|
      get "/accounts", {}, { "User-Agent" => browser }

      assert_match css_file, response.body, "user-agent #{browser} should have css file #{css_file}"
    end
  end
end
