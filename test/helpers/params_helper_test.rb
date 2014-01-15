require 'test_helper'

class ParamsHelperTest < ActionView::TestCase

  test "should pack/unpack params" do
    params = { doge: 'wow', omg: 'such params', much_data: 'so short' }

    short = shorten_params(params)
    long = unshorten_params(short)

    assert_equal params, long, "should pack and unpack correctly"
  end

end
