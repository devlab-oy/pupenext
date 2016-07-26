require 'test_helper'

class Category::ProductTest < ActiveSupport::TestCase
  fixtures %w(
    category/links
    category/products
    products
  )

  setup do
    @shirts = category_products :product_category_shirts
    @pants  = category_products :product_category_pants
  end

  test 'fixtures are valid' do
    assert @shirts.valid?, @shirts.errors.full_messages
    assert @pants.valid?,  @pants.errors.full_messages
  end

  test 'associations work' do
    assert_equal "Acme Corporation", @shirts.company.nimi

    assert_equal 2, @shirts.links.size
    assert_includes @shirts.links, category_links(:product_category_shirts_hammer)
    assert_includes @shirts.links, category_links(:product_category_shirts_ski)

    assert_equal 1, @pants.products.size
    assert_includes @pants.links, category_links(:product_category_pants_helmet)
  end

  test '.tree' do
    tree = Category::Product.tree

    paidat      = tree.find { |node| node['nimi'] == 'Paidat' }
    t_paidat    = paidat['children'].find { |node| node['nimi'] == 'T-paidat' }
    v_aukkoiset = t_paidat['children'].find { |node| node['nimi'] == 'V-aukkoiset' }

    housut = tree.find { |node| node['nimi'] == 'Housut' }

    assert_equal 2, tree.size
    assert_equal 1, paidat['children'].size
    assert_equal 0, housut['children'].size
    assert_equal 1, t_paidat['children'].size
    assert_equal 0, v_aukkoiset['children'].size
  end

  test '#tree' do
    assert_equal 1, @shirts.tree['children'].size
    assert_equal 1, @shirts.tree['children'][0]['children'].size
    assert_equal 0, @shirts.tree['children'][0]['children'][0]['children'].size

    assert_equal 0, @pants.tree['children'].size
  end
end
