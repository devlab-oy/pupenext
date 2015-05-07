require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  def setup
    @account = accounts(:account_100)
    @project =  qualifiers(:project_in_use)
  end

  test "assert fixtures are valid" do
    assert @account.valid?, @account.errors.messages
  end

  test "assert sti works" do
    assert_equal "S", @account.internal.tyyppi
    assert_equal "U", @account.external.tyyppi
    assert_equal "A", @account.vat.tyyppi
    assert_equal "B", @account.profit.tyyppi
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
    other_account.sisainen_taso = nil
    other_account.alv_taso = nil
    other_account.tulosseuranta_taso = nil
    assert other_account.valid?, "different company, same tilino ok"
  end

  # test "accounts project needs to be in use" do
  #   project_not_in_use = Qualifier::Project.not_in_use.first
  #   @account.project = project_not_in_use
  #
  #   #account needs to be saved. Project_not_in_use goes to db
  #   #After we reload @account.project = nil because Qualifier has default_scope
  #   @account.save
  #   @account.reload
  #
  #   assert_nil @account.project
  # end

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

  test "toimijaliitos and manuaali_esto default to empty strings" do
    @account.toimijaliitos, @account.manuaali_esto = nil
    @account.save

    assert_equal "", @account.reload.toimijaliitos
    assert_equal "", @account.reload.toimijaliitos
  end
end
