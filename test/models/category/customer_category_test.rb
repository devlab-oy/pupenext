require 'test_helper'

class Category::CustomerTest < ActiveSupport::TestCase
  fixtures %w(
    customers
    category/customers
  )

  setup do
    @dealers  = category_customers :customer_category_dealers
    @partners = category_customers :customer_category_partners
  end

  test 'fixtures are valid' do
    assert @dealers.valid?, @dealers.errors.full_messages
    assert @partners.valid?, @partners.errors.full_messages
  end

  test 'associations work' do
    assert_equal "Acme Corporation", @dealers.company.nimi
  end
end
