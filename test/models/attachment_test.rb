require 'test_helper'

class AttachmentTest < ActiveSupport::TestCase
  fixtures %w{attachments products}

  setup do
    @product_image_1 = attachments(:product_image_1)
    @hammer          = products(:hammer)
  end

  test "fixtures are valid" do
    assert @product_image_1.valid?, @product_image_1.errors.full_messages
  end

  test "associations work" do
    assert_equal @hammer, @product_image_1.product
  end

  test "product images scope works" do
    assert_equal 1, Attachment.product_images.count
  end

  test "thumbnails scope works" do
    assert_equal 1, Attachment.thumbnails.count
  end
end
