require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  fixtures %w(
    accounts
    head/voucher_rows
    heads
    qualifiers
    sum_levels
    fixed_assets/commodities
  )

  setup do
    @account = accounts :account_100
    @commodity = accounts :account_commodity
    @project =  qualifiers :project_in_use
  end

  test "assert fixtures are valid" do
    refute_empty Account.all

    Account.all.each do |account|
      assert account.valid?, "Account #{account.nimi}: #{account.errors.full_messages}"
    end
  end

  test "assert sti works" do
    assert_equal "S", @account.internal.tyyppi
    assert_equal "U", @account.external.tyyppi
    assert_equal "A", @account.vat.tyyppi
    assert_equal "B", @account.profit.tyyppi
  end

  test 'relations' do
    assert_equal Qualifier::Project, @account.project.class
    assert_equal Qualifier::Target, @account.target.class
    assert_equal Qualifier::CostCenter, @account.cost_center.class

    assert_equal SumLevel::Internal, @account.internal.class
    assert_equal SumLevel::External, @account.external.class
    assert_equal SumLevel::Vat, @account.vat.class
    assert_equal SumLevel::Profit, @account.profit.class
    assert_equal SumLevel::Commodity, @commodity.commodity.class

    assert @account.vouchers.count > 0
    assert @account.voucher_rows.count > 0
    assert @commodity.commodities.count > 0
  end

  test "make sure relations are correct" do
    # New instanse of working account
    account = @account.dup
    @account.delete

    account.sisainen_taso = nil
    assert account.valid?

    account.sisainen_taso = ''
    assert account.valid?, 'empty string should be ok'

    account.sisainen_taso = 'kissa'
    refute account.valid?, 'taso should be in the db'

    account.sisainen_taso = '3'
    assert account.valid?, account.errors.messages

    account.ulkoinen_taso = 'kissa'
    refute account.valid?, 'taso should be in the db'

    account.ulkoinen_taso = '112'
    assert account.valid?, account.errors.messages

    account.alv_taso = nil
    assert account.valid?

    account.alv_taso = ''
    assert account.valid?, 'empty string should be ok'

    account.alv_taso = 'kissa'
    refute account.valid?, 'taso should be in the db'

    account.alv_taso = 'fi307'
    assert account.valid?, account.errors.messages

    account.tulosseuranta_taso = nil
    assert account.valid?

    account.tulosseuranta_taso = ''
    assert account.valid?, 'empty string should be ok'

    account.tulosseuranta_taso = 'kissa'
    refute account.valid?, 'taso should be in the db'

    account.tulosseuranta_taso = '1'
    assert account.valid?, account.errors.messages
  end

  test "ulkoinen_taso cant be empty" do
    @account.ulkoinen_taso = ''
    refute @account.valid?
  end

  test "nimi cant be empty" do
    @account.nimi = ''
    refute @account.valid?

    @account.nimi = 'Tutkimusmenot'
    assert @account.valid?
  end

  test "tilino cant be empty" do
    @account.tilino = ''
    refute @account.valid?
  end

  test "tilino needs to be unique inside company" do
    other_account = @account.dup
    refute other_account.valid?, "tilino needs to be unique"

    other_account.tilino = '121212'
    assert other_account.valid?

    other_account = @account.dup
    other_account.company = companies(:estonian)
    Current.company = companies(:estonian)
    other_account.sisainen_taso = nil
    other_account.alv_taso = nil
    other_account.tulosseuranta_taso = nil
    assert other_account.valid?, "different company, same tilino ok"
  end

  test "accounts project needs to be in use" do
    @account.project = Qualifier::Project.not_in_use.first

    @account.save
    @account.reload

    assert "E", @account.project.kaytossa
  end

  test "kustp, kohde and projekti default to 0" do
    @account.project, @account.cost_center, @account.target = nil

    @account.save

    assert_equal 0, @account.projekti
    assert_equal 0, @account.kustp
    assert_equal 0, @account.kohde
  end

  test 'get all EVL accounts' do
    company = companies(:acme)
    assert_equal 2, company.accounts.evl_accounts.count
  end
end
