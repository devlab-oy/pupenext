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
    assert other_account.valid?, "different company, same tilino ok"
  end

  test "accounts project needs to be in use" do
    project_not_in_use = Qualifier::Project.not_in_use.first
    @account.project = project_not_in_use

    #account needs to be saved. Project_not_in_use goes to db
    #After we reload @account.project = nil because Qualifier has default_scope
    @account.save
    @account.reload

    assert_nil @account.project
  end
end
