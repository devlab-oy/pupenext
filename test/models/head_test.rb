require 'test_helper'

class HeadTest < ActiveSupport::TestCase
  fixtures %w(
    customers
    head_details
    heads
  )

  test 'fixtures are valid' do
    refute_empty Head.all

    Head.all.each do |head|
      assert head.valid? head.errors.full_messages
    end
  end

  test 'associations' do
    assert_equal head_details(:two), heads(:pi_H).detail
    assert_equal head_details(:one), heads(:si_one).detail

    assert_equal customers(:stubborn_customer), heads(:pi_H).customer
    assert_equal customers(:lissu),             heads(:si_one).customer
  end
end
