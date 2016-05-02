require 'test_helper'

class HeadDetailTest < ActiveSupport::TestCase
  fixtures %w(
    head_details
  )

  test 'fixtures are valid' do
    refute_empty HeadDetail.all

    HeadDetail.all.each do |head_detail|
      assert head_detail.valid? head_detail.errors.full_messages
    end
  end
end
