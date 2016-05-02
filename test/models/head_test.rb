require 'test_helper'

class HeadTest < ActiveSupport::TestCase
  fixtures %w(
    head_details
    heads
  )

  test 'fixtures are valid' do
    refute_empty Head.all

    Head.all.each do |head|
      assert head.valid? head.errors.full_messages
    end
  end
end
