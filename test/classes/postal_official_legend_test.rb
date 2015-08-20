require 'test_helper'

class PostalOfficialLegendTest < ActiveSupport::TestCase
  test 'should get proper legend' do
    legends = PostalOfficialLegend.options
    assert_equal 'Itella Express City 00', legends[:"Pupesoft / Itella"][:"Express City 00"]
  end
end
