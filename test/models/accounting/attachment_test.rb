require 'test_helper'

class Accounting::AttachmentTest < ActiveSupport::TestCase

  def setup
    # Valid accounting attachment
    @attachment = accounting_attachments(:one)
  end

  test 'fixture should be valid' do
    assert @attachment.valid?
  end

end
