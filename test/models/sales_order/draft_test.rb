require 'test_helper'

class SalesOrder::DraftTest < ActiveSupport::TestCase
  fixtures %w(
    sales_order/drafts
  )

  test 'fixtures are valid' do
    SalesOrder::Draft.all.each do |draft|
      assert draft.valid?
    end
  end
end
