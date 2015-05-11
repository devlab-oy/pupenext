require 'test_helper'

class BaseModelTest < ActiveSupport::TestCase
  test 'should raise exception without current company' do
    assert_raise CurrentCompanyNil do
      Current.company = nil
      Account.first
    end
  end
end

