require 'test_helper'

class GitPullTest < ActiveSupport::TestCase
  fixtures %w(git_pull)

  setup do
    GitPull.update_pupenext_hash

    @last = GitPull.get_pupenext_hash
    @curhash = GitPull.get_current_git_hash
  end

  test "update current git hash to last pull in database" do
    assert_equal @last.hash_pupenext, @curhash
  end
end
