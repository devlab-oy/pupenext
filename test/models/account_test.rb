require 'test_helper'

class AccountTest < ActiveSupport::TestCase

  def setup
    @a = accounts(:first)
  end

  test "assert fixtures are valid" do
    assert @a.valid?, @a.errors.messages
  end

  test "account has a company" do
    assert_not_nil @a.company
  end

  test "ulkoinen_taso cant be empty" do
    @a.ulkoinen_taso = ''
    refute @a.valid?
  end

  test "nimi cant be empty" do
    @a.nimi = ''
    refute @a.valid?
  end

  test "tilino cant be empty" do
    @a.tilino = ''
    refute @a.valid?
  end


end
