require 'test_helper'

class UserProfileTest < ActiveSupport::TestCase
  fixtures %w(
    menus
    permissions
    user_profiles
  )

  test 'fixtures are valid' do
    refute_empty UserProfile.all

    UserProfile.all.each do |record|
      assert record.valid?, "Profile #{record.nimi}: #{record.errors.full_messages}"
    end
  end
end
