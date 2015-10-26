require 'test_helper'

class Attachment::ProductAttachmentTest < ActiveSupport::TestCase
  fixtures %w{
    attachment/product_attachments
    products
  }

  setup do
    @product_image_1 = attachment_product_attachments(:product_image_1)
    @hammer          = products(:hammer)
  end

  test "fixtures are valid" do
    assert @product_image_1.valid?, @product_image_1.errors.full_messages
  end

  test "associations work" do
    assert_equal @hammer, @product_image_1.product

    @product_image_1.liitos = 'lasku'
    @product_image_1.save

    assert_not_respond_to @product_image_1.becomes(Attachment), :product
  end

  test "images scope works" do
    assert_equal 2, Attachment::ProductAttachment.images.count
  end

  test "thumbnails scope works" do
    assert_equal 1, Attachment::ProductAttachment.thumbnails.count
  end
end
