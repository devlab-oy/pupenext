require 'test_helper'

class SalesInvoicesControllerTest < ActionController::TestCase
  fixtures %w(
    heads
  )

  setup do
    login users(:bob)
    @invoice = heads :si_one
  end

  test "should get invoice xml" do
    get :show, id: @invoice, format: :xml
    assert_response :success

    example = File.read Rails.root.join('test', 'assets', 'example_finvoice.xml')
    xml_example = Nokogiri::XML example
    xml_response = Nokogiri::XML response.body

    assert_equal xml_example.to_s, xml_response.to_s
  end
end
