require 'test_helper'

class UserTest < ActiveSupport::TestCase
  fixtures %w(
    download/downloads
    download/files
    menus
    user_profiles
    users
  )

  setup do
    @joe = users(:joe)
    @bob = users(:bob)
  end

  test 'user model' do
    assert User.new
  end

  test 'fixture is valid' do
    assert @joe.valid?
  end

  test 'relations' do
    assert_not_nil @joe.company
    assert @joe.downloads.count > 0
    assert @joe.files.count > 0
  end

  test 'user has update permissions' do
    assert_equal 0, @joe.permissions.update_permissions.count
  end

  test 'read access' do
    assert @joe.permissions.read_access '/customers'
  end

  test 'update access' do
    assert @joe.permissions.update_access '/companies'
  end

  test 'can read' do
    assert @joe.can_read? '/customers'
    assert @bob.can_read? '/customers'
    refute users(:max).can_read? '/test'
  end

  test 'can update' do
    refute @joe.can_update? '/currencies'
    refute @joe.can_update? '/companies'

    assert @bob.can_update? '/currencies'
    assert @bob.can_update? '/companies'
  end

  test 'classic permissions' do
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

  test 'user has correct css' do
    @joe.company.parameter.kayttoliittyma = 'U'
    @joe.kayttoliittyma = ''
    refute @joe.classic_ui?, 'company set new, joe set nothing, should be new'
    @joe.kayttoliittyma = 'U'
    refute @joe.classic_ui?, 'company set new, joe set new, should be new'
    @joe.kayttoliittyma = 'C'
    assert @joe.classic_ui?, 'company set new, joe set classic, should be classic'

    @joe.company.parameter.kayttoliittyma = 'C'
    @joe.kayttoliittyma = ''
    assert @joe.classic_ui?, 'company set classic, joe set nothing, show be classic'
    @joe.kayttoliittyma = 'U'
    refute @joe.classic_ui?, 'company set classic, joe set new, show be new'
    @joe.kayttoliittyma = 'C'
    assert @joe.classic_ui?, 'company set classic, joe set classic, show be classic'

    @joe.company.parameter.kayttoliittyma = ''
    @joe.kayttoliittyma = ''
    assert @joe.classic_ui?, 'company set nothing, joe set nothing, should be classic'
    @joe.kayttoliittyma = 'U'
    refute @joe.classic_ui?, 'company set nothing, joe set new, should be new'
    @joe.kayttoliittyma = 'C'
    assert @joe.classic_ui?, 'company set nothing, joe set classic, should be classic'
  end

  test 'update permissions' do
    # all joes permissions are lukittu, and he does not belong to a profile
    refute_empty @joe.permissions
    @joe.update_attributes! profiilit: ''
    @joe.permissions.update_all lukittu: 1

    assert_no_difference '@joe.permissions.count' do
      @joe.update_permissions
    end

    # all permissions all lukittu, but profile has permissions we don't have
    profile = user_profiles(:acme_profile_1).dup
    profile.update_attributes!(
      jarjestys: 1,
      kuka: 'new profile',
      nimi: 'new/app',
      profiili: 'new profile',
      sovellus: 'new menu',
    )
    @joe.update_attributes! profiilit: 'new profile'

    # we should have one new permission from new profile
    assert_difference '@joe.permissions.count' do
      @joe.update_permissions
    end

    # we should get only the one permission from the new profile
    Permission.delete_all
    assert_equal 0, @joe.permissions.count

    assert_difference '@joe.permissions.count' do
      @joe.update_permissions
    end
  end

  test 'valid taso' do
    [1, 2, 3, 9, nil, ''].each do |taso|
      @joe.taso = taso
      assert @joe.valid?, @joe.errors.full_messages
    end

    [4, 5, 6, 'foo'].each do |invalid_taso|
      assert_raise(ArgumentError) do
        @joe.taso = invalid_taso
      end
    end
  end
end
