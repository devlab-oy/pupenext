require 'test_helper'

class SalesInvoicesControllerTest < ActionController::TestCase
  fixtures %w(
    heads
  )

  setup do
    login users(:bob)
    @invoice = heads :si_one
  end

  test "should get xml" do
    get :show, id: @invoice, format: :xml
    assert_response :success
  end
end
