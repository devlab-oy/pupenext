require 'test_helper'

class Accounting::RowTest < ActiveSupport::TestCase

  def setup
    # Valid accounting row
    @row = accounting_rows(:one)
  end

  test 'fixture should be valid' do
    assert @row.valid?
  end

end
