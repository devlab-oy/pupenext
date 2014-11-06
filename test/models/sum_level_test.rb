require 'test_helper'

class SumLevelTest < ActiveSupport::TestCase
  def setup
    @internal = sum_levels(:internal)
    @external = sum_levels(:external)
    @vat = sum_levels(:vat)
    @profit = sum_levels(:profit)
  end
  
  test "fixtures should be valid" do
    assert @internal.valid?
    assert @external.valid?
    assert @vat.valid?
    assert @profit.valid?
  end

end
