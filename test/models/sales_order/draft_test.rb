require 'minitest/mock'
require 'test_helper'

class SalesOrder::DraftTest < ActiveSupport::TestCase
  fixtures %w(
    sales_order/drafts
    users
  )

  setup do
    Current.user = users(:bob)
  end

  test 'fixtures are valid' do
    SalesOrder::Draft.all.each do |draft|
      assert draft.valid?
    end
  end

  test '#mark_as_done' do
    SalesOrder::Draft.all.each do |draft|
      mark_as_done = proc do
        draft.tila = 'L'
        draft.save(validate: false)
      end

      LegacyMethods.stub(:pupesoft_function, mark_as_done) do
        assert_difference 'SalesOrder::Draft.count', -1 do
          draft.mark_as_done
        end
      end
    end
  end
end
