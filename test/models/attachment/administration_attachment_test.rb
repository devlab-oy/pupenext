require 'test_helper'

class Attachment::AdministrationAttachmentTest < ActiveSupport::TestCase
  fixtures %w{
    attachment/administration_attachments
  }

  setup do
    @logo = attachment_administration_attachments(:logo)
  end

  test "fixtures are valid" do
    assert @logo.valid?, @logo.errors.full_messages
  end

  test "logo works" do
    assert_equal "logo_data", Attachment::AdministrationAttachment.logo.data
  end
end
