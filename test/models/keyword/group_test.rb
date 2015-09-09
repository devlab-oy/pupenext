require 'test_helper'

class Keyword::GroupTest < ActiveSupport::TestCase
  fixtures %w(keywords)

  setup do
    @group = keywords(:group_1)
  end

  test 'fixtures are valid' do
    assert @group.valid?
  end
end
