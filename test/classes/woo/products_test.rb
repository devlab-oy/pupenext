require 'minitest/mock'
require 'test_helper'

class Woo::ProductsTest < ActiveSupport::TestCase
  fixtures %w(
    products
    sales_order/rows
  )

  setup do
    @woocommerce = Woo::Products.new(
      store_url: 'dummy_url',
      consumer_key: 'test_key',
      consumer_secret: 'test_secret',
      company_id: companies(:acme).id,
    )

    Product.update_all(hinnastoon: '')
    products(:ski).update(hinnastoon: 'w')

    Keyword::WooCheckpoint.delete_all
    Product::Transaction.delete_all
  end

  test 'should initialize' do
    assert_instance_of Woo::Products, @woocommerce
  end

  test 'get products' do
    assert_equal 1, @woocommerce.send(:products).count
  end

  test 'product hash' do
    response = {
      name: 'Combosukset',
      slug: 'ski1',
      sku: 'ski1',
      type: 'simple',
      description: nil,
      short_description: nil,
      regular_price: '0.0',
      manage_stock: true,
      stock_quantity: '0.0',
      status: 'pending',
    }

    product = @woocommerce.send(:products).first
    assert_equal response, @woocommerce.send(:product_hash, product)
  end

  test 'values in product hash can be added with keywords' do
    Keyword::WooField.create!(selite: 'product_mass', selitetark: 'tuotemassa')

    response = {
      name: 'Combosukset',
      slug: 'ski1',
      sku: 'ski1',
      type: 'simple',
      description: nil,
      short_description: nil,
      regular_price: '0.0',
      manage_stock: true,
      stock_quantity: '0.0',
      status: 'pending',
      product_mass: 0,
    }

    product = @woocommerce.send(:products).first
    assert_equal response, @woocommerce.send(:product_hash, product)
  end

  test 'values in product hash can be overriden with keywords' do
    Keyword::WooField.create!(selite: 'slug', selitetark: 'tuotemerkki')

    response = {
      name: 'Combosukset',
      slug: 'Karhu',
      sku: 'ski1',
      type: 'simple',
      description: nil,
      short_description: nil,
      regular_price: '0.0',
      manage_stock: true,
      stock_quantity: '0.0',
      status: 'pending',
    }

    product = @woocommerce.send(:products).first
    assert_equal response, @woocommerce.send(:product_hash, product)
  end

  test 'values in product hash can be removed with keywords' do
    Keyword::WooField.create!(selite: 'name', selitetark: '')

    response = {
      slug: 'ski1',
      sku: 'ski1',
      type: 'simple',
      description: nil,
      short_description: nil,
      regular_price: '0.0',
      manage_stock: true,
      stock_quantity: '0.0',
      status: 'pending',
    }

    product = @woocommerce.send(:products).first
    assert_equal response, @woocommerce.send(:product_hash, product)
  end

  test 'checkpoint is created after first create run' do
    @woocommerce.stub :get_sku, nil do
      @woocommerce.stub :woo_post, 'id' => 1 do
        assert_difference 'Keyword::WooCheckpoint.count' do
          @woocommerce.create
        end
      end
    end

    assert_in_delta Keyword::WooCheckpoint.last_run_at(:create), Time.current, 10
  end

  test 'checkpoint is updated if already present when creating products' do
    @woocommerce.stub :get_sku, nil do
      @woocommerce.stub :woo_post, 'id' => 1 do
        assert_difference 'Keyword::WooCheckpoint.count' do
          2.times { @woocommerce.create }
        end
      end
    end

    assert_in_delta Keyword::WooCheckpoint.last_run_at(:create), Time.current, 10
  end

  test 'checkpoint is updated after updating stocks' do
    @woocommerce.stub :get_sku, {} do
      @woocommerce.stub :woo_put, 'id' => 1 do
        assert_difference 'Keyword::WooCheckpoint.count' do
          2.times { @woocommerce.update }
        end
      end
    end

    assert_in_delta Keyword::WooCheckpoint.last_run_at(:update), Time.current, 10
  end

  test 'different timestamps in checkpoint work independently' do
    @woocommerce.stub :get_sku, nil do
      @woocommerce.stub :woo_post, 'id' => 1 do
        assert_difference 'Keyword::WooCheckpoint.count' do
          travel(-1.day) { @woocommerce.create }
          @woocommerce.update
        end
      end
    end

    refute_in_delta Keyword::WooCheckpoint.last_run_at(:create), Time.current, 10
    assert_in_delta Keyword::WooCheckpoint.last_run_at(:update), Time.current, 10
  end

  test 'all products are created if no create timestamp in checkpoint' do
    counter = 0

    block = proc do
      counter += 1
      { 'id' => 1 }
    end

    @woocommerce.stub :get_sku, nil do
      @woocommerce.stub :woo_post, block do
        @woocommerce.create
      end
    end

    assert_equal 1, counter
  end

  test 'only new products are created when create timestamp is found' do
    products(:ski).update!(luontiaika: 1.second.ago)

    Keyword::WooCheckpoint.update_timestamp(:create)

    counter = 0

    block = proc do
      counter += 1
      { 'id' => 1 }
    end

    @woocommerce.stub :get_sku, nil do
      @woocommerce.stub :woo_post, block do
        @woocommerce.create
      end
    end

    assert_equal 0, counter
  end

  test 'all products can be created by passing option even when timestamp is found' do
    products(:ski).update!(luontiaika: 1.second.ago)

    Keyword::WooCheckpoint.update_timestamp(:create)

    counter = 0

    block = proc do
      counter += 1
      { 'id' => 1 }
    end

    @woocommerce.stub :get_sku, nil do
      @woocommerce.stub :woo_post, block do
        @woocommerce.create(all: true)
      end
    end

    assert_equal 1, counter
  end

  test 'all products are updated if no update timestamp in checkpoint' do
    counter = 0

    block = proc do
      counter += 1
      { 'id' => 1 }
    end

    @woocommerce.stub :get_sku, {} do
      @woocommerce.stub :woo_put, block do
        @woocommerce.update
      end
    end

    assert_equal 1, counter
  end

  test 'only products with new rows are updated when update timestamp is found' do
    Keyword::WooCheckpoint.update_timestamp(:update)

    counter = 0

    block = proc do
      counter += 1
      { 'id' => 1 }
    end

    @woocommerce.stub :get_sku, {} do
      @woocommerce.stub :woo_put, block do
        @woocommerce.update
      end
    end

    assert_equal 0, counter
  end

  test 'products with new rows are updated when timestamp is found' do
    Keyword::WooCheckpoint.update_timestamp(:update)

    products(:ski).sales_order_rows.create!(laadittu: 1.second.from_now)

    counter = 0

    block = proc do
      counter += 1
      { 'id' => 1 }
    end

    @woocommerce.stub :get_sku, {} do
      @woocommerce.stub :woo_put, block do
        @woocommerce.update
      end
    end

    assert_equal 1, counter
  end

  test 'products with new transactions are updated when timestamp is found' do
    Keyword::WooCheckpoint.update_timestamp(:update)

    products(:ski).transactions.create!(laadittu: 1.second.from_now)

    counter = 0

    block = proc do
      counter += 1
      { 'id' => 1 }
    end

    @woocommerce.stub :get_sku, {} do
      @woocommerce.stub :woo_put, block do
        @woocommerce.update
      end
    end

    assert_equal 1, counter
  end

  test 'all products can be updated by passing option even when timestamp is found' do
    Keyword::WooCheckpoint.update_timestamp(:update)

    counter = 0

    block = proc do
      counter += 1
      { 'id' => 1 }
    end

    @woocommerce.stub :get_sku, {} do
      @woocommerce.stub :woo_put, block do
        @woocommerce.update(all: true)
      end
    end

    assert_equal 1, counter
  end
end
