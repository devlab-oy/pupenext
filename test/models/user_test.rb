require 'test_helper'

class UserTest < ActiveSupport::TestCase
  fixtures %w(users)

  setup do
    @joe = users(:joe)
    @bob = users(:bob)
  end

  test "user model" do
    assert User.new
  end

  test "fixture is valid" do
    assert @joe.valid?
  end

  test "user has a company" do
    assert_not_nil @joe.company
  end

  test "user has update permissions" do
    assert_equal 0, @joe.permissions.update_permissions.count
  end

  test 'read access' do
    assert @joe.permissions.read_access '/customers'
  end

  test 'update access' do
    assert @joe.permissions.update_access '/companies'
  end

  test "can read" do
    assert @joe.can_read? '/customers'
    assert @bob.can_read? '/customers'
    refute users(:max).can_read? '/test'
  end

  test "can update" do
    refute @joe.can_update? '/currencies'
    refute @joe.can_update? '/companies'

    assert @bob.can_update? '/currencies'
    assert @bob.can_update? '/companies'
  end

  test "classic permissions" do
    refute @joe.can_read?   '/customers', classic: true
    refute @bob.can_read?   '/customers', classic: true
    refute @joe.can_update? '/customers', classic: true
    refute @bob.can_update? '/customers', classic: true

    refute @joe.can_read?   'tulosta_tuotetarrat.php'
    refute @bob.can_read?   'tulosta_tuotetarrat.php'
    refute @joe.can_update? 'tulosta_tuotetarrat.php'
    refute @bob.can_update? 'tulosta_tuotetarrat.php'

    assert @joe.can_read?   'tulosta_tuotetarrat.php', classic: true
    assert @bob.can_read?   'tulosta_tuotetarrat.php', classic: true
    refute @joe.can_update? 'tulosta_tuotetarrat.php', classic: true
    assert @bob.can_update? 'tulosta_tuotetarrat.php', classic: true
  end

  test "user has correct css" do
    @joe.company.parameter.kayttoliittyma = 'U'
    @joe.kayttoliittyma = ''
    refute @joe.classic_ui?, "company set new, joe set nothing, should be new"
    @joe.kayttoliittyma = 'U'
    refute @joe.classic_ui?, "company set new, joe set new, should be new"
    @joe.kayttoliittyma = 'C'
    assert @joe.classic_ui?, "company set new, joe set classic, should be classic"

    @joe.company.parameter.kayttoliittyma = 'C'
    @joe.kayttoliittyma = ''
    assert @joe.classic_ui?, "company set classic, joe set nothing, show be classic"
    @joe.kayttoliittyma = 'U'
    refute @joe.classic_ui?, "company set classic, joe set new, show be new"
    @joe.kayttoliittyma = 'C'
    assert @joe.classic_ui?, "company set classic, joe set classic, show be classic"

    @joe.company.parameter.kayttoliittyma = ''
    @joe.kayttoliittyma = ''
    assert @joe.classic_ui?, "company set nothing, joe set nothing, should be classic"
    @joe.kayttoliittyma = 'U'
    refute @joe.classic_ui?, "company set nothing, joe set new, should be new"
    @joe.kayttoliittyma = 'C'
    assert @joe.classic_ui?, "company set nothing, joe set classic, should be classic"
  end
end
