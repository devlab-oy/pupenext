require 'test_helper'

class QualifierTest < ActiveSupport::TestCase
  def setup
    @project_with_account = qualifiers(:project_in_use)
  end

  test "if someone tries to deactivate qualifier check account assosiation" do
    @project_with_account.deactivate!
    refute @project_with_account.valid?

    @project_with_account.activate!
    assert @project_with_account.valid?, @project_with_account.errors.full_messages
  end
end
