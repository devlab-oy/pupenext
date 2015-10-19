require 'test_helper'

class AttachmentTest < ActiveSupport::TestCase
  fixtures %w{attachments products}

  setup do
    @product_attachment_1 = attachments(:product_attachment_1)
    @hammer               = products(:hammer)
  end

  test "fixtures are valid" do
    assert @product_attachment_1.valid?, @product_attachment_1.errors.full_messages
  end

  test "associations work" do
    assert_equal @hammer, @product_attachment_1.product
  end
end
