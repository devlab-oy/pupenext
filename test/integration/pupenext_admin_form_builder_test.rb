require 'test_helper'

class PupenextAdminFormBuilderTest < ActionDispatch::IntegrationTest
  include LoginHelper

  fixtures %w(accounts keywords)

  # Use accounts -controller for testing AdminFormBuilder

  setup do
    login users(:bob)
    @account = accounts(:account_100)
  end

  test "we should see all fields if nothing is defined in default alias_set" do
    get edit_account_path(@account)
    assert_response :success

    # 14 rows + created_by and modified_by
    assert_select "tr", { count: 16 }, 'all rows should be visible'
    assert_select "input[id=account_nimi]", { count: 1 }, 'nimi field must be present'
  end

  test "we should only see fields defined visible in default alias_set" do
    attribute = keywords(:mysql_alias_1)

    attribute.update! database_field: 'tili.nimi', set_name: 'Default', visibility: :visible

    get edit_account_path(@account)
    assert_response :success

    # we should see only three rows: nimi, created_by, and modified_by
    assert_select "tr", { count: 3 }, 'only three rows should be visible'
    assert_select "input[id=account_nimi]", { count: 1 }, 'nimi field must be present'
  end

  test "we should not see fields defined hidden in default alias_set" do
    attribute = keywords(:mysql_alias_1)

    attribute.update! database_field: 'tili.nimi', set_name: 'Default', visibility: :hidden

    get edit_account_path(@account)
    assert_response :success

    # we should see only two: created_by and modified_by
    assert_select "tr", { count: 2 }, 'only two rows should be visible'
    assert_select "input[id=account_nimi]", { count: 0 }, 'nimi cannot be present'
  end

  test "we should not see any fields if no fields are visible in given alias_set" do
    attribute = keywords(:mysql_alias_1)
    permission = permissions(:bob_accounts_update)

    attribute.update! database_field: 'tili.nimi', set_name: 'bobset', visibility: :hidden
    permission.update! alias_set: 'bobset'

    get edit_account_path(@account), alias_set: 'bobset'
    assert_response :success

    # we should see only two: created_by and modified_by
    assert_select "tr", { count: 2 }, 'only two rows should be visible'
    assert_select "input[id=account_nimi]", { count: 0 }, 'nimi cannot be present'
  end

  test "we should see visible fields in given alias_set" do
    attribute = keywords(:mysql_alias_1)
    permission = permissions(:bob_accounts_update)

    attribute.update! database_field: 'tili.nimi', set_name: 'bobset', visibility: :visible
    permission.update! alias_set: 'bobset'

    get edit_account_path(@account), alias_set: 'bobset'
    assert_response :success

    # we should see only three: nimi, created_by, and modified_by
    assert_select "tr", { count: 3 }, 'only three rows should be visible'
    assert_select "input[id=account_nimi]", { count: 1 }, 'nimi must be present'
  end
end
