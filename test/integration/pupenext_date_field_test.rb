require 'test_helper'

class PupenextDateFieldTest < ActionDispatch::IntegrationTest
  include LoginHelper

  setup do
    login users(:bob)
    @fy = fiscal_years(:one)
  end

  test "we should get an error message in invalid date" do
    error = I18n.t 'errors.messages.not_a_date'
    params = {
      tilikausi_loppu: {
        day: 32,
        month: 12,
        year: 2014
      }
    }

    patch fiscal_year_path(@fy), fiscal_year: params

    assert_response :success, 'successfull save should redirect to edit'
    assert_includes response.body, error
  end
end
