require 'test_helper'

class PostalOfficialLegendTest < ActiveSupport::TestCase
  test 'should get proper legend' do
    legends = PostalOfficialLegend.options
    assert_equal Array, legends.class
  end
end
