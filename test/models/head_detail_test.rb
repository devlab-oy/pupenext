require 'test_helper'

class HeadDetailTest < ActiveSupport::TestCase
  fixtures %w(
    head_details
    heads
  )

  test 'fixtures are valid' do
    refute_empty HeadDetail.all

    HeadDetail.all.each do |head_detail|
      assert head_detail.valid? head_detail.errors.full_messages
    end
  end

  test 'associations' do
    assert_equal heads(:si_one), head_details(:one).head
    assert_equal heads(:pi_H),   head_details(:two).head
  end
end
