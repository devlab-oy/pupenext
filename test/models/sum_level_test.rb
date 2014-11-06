require 'test_helper'

class SumLevelTest < ActiveSupport::TestCase
  def setup
    @internal = sum_levels(:internal)
    @external = sum_levels(:external)
    @vat = sum_levels(:vat)
  end
  
  
  test "" do
      
  end
end
