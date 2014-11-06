require 'test_helper'

class SumLevelTest < ActiveSupport::TestCase
  def setup
    @internal = sum_levels(:internal)
    @external = sum_levels(:external)
    @vat = sum_levels(:vat)
    @profit = sum_levels(:profit)
  end

  test "sum level is required" do
    @internal.taso = ''

    refute @internal.valid?
  end

end
