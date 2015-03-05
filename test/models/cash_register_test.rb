require 'test_helper'

class CashRegisterTest < ActiveSupport::TestCase

  def setup
    @q = cash_registers(:first)
  end

  test "assert fixtures are valid" do
    assert @q.valid?, @q.errors.messages
  end

  test "cash register has a company" do
    assert_not_nil @q.company
  end

  test "name cant be empty" do
    @q.nimi = ''
    refute @q.valid?
  end

  test "kassa cant be empty" do
    @q.kassa = ''
    refute @q.valid?
  end

  test "pankkikortti cant be empty" do
    @q.pankkikortti = ''
    refute @q.valid?
  end

  test "luottokortti cant be empty" do
    @q.luottokortti = ''
    refute @q.valid?
  end

  test "kateistilitys cant be empty" do
    @q.kateistilitys = ''
    refute @q.valid?
  end

  test "kassaerotus cant be empty" do
    @q.kassaerotus = ''
    refute @q.valid?
  end

end
