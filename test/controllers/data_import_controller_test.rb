require 'test_helper'

class DataImportControllerTest < ActionController::TestCase
  fixtures %w(
    customers
    keyword/product_information_types
    keyword/product_keyword_types
    keyword/product_parameter_types
    product/keywords
    products
    sales_order/detail_rows
    sales_order/details
  )

  setup do
    login users(:bob)

    @default_detail_product = products(:default_detail_product).tuoteno
    @default_detail_customer = customers(:default_detail_customer).asiakasnro
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test 'should add customer sales' do
    file = fixture_file_upload 'files/customer_sales_test.xlsx'
    SalesOrder::Detail.delete_all

    params = {
      file: file,
      'month_year(2i)' => 1,
      'month_year(1i)' => 2016,
    }

    assert_difference 'SalesOrder::Detail.count', 1 do
      assert_difference 'SalesOrder::DetailRow.count', 2 do
        post :customer_sales, data_import: params
      end
    end

    assert assigns(:spreadsheet)
    assert_response :success
  end

  test 'should add customer sales with default customer number and default product' do
    file = fixture_file_upload 'files/customer_sales_test.xlsx'
    SalesOrder::Detail.delete_all

    params = {
      file: file,
      'month_year(2i)' => 1,
      'month_year(1i)' => 2016,
      product: @default_detail_product,
      customer_number: @default_detail_customer,
    }

    assert_difference 'SalesOrder::Detail.count', 1 do
      assert_difference 'SalesOrder::DetailRow.count', 2 do
        post :customer_sales, data_import: params
      end
    end

    assert assigns(:spreadsheet)
    assert_response :success
  end

  test 'should delete customer sales' do
    file = fixture_file_upload 'files/customer_sales_test.xlsx'
    SalesOrder::Detail.delete_all

    params = {
      file: file,
      'month_year(2i)' => 1,
      'month_year(1i)' => 2016,
    }

    assert_difference 'SalesOrder::Detail.count', 1 do
      assert_difference 'SalesOrder::DetailRow.count', 2 do
        post :customer_sales, data_import: params
      end
    end

    assert assigns(:spreadsheet)
    assert_response :success

    params = {
      'month_year(2i)' => 1,
      'month_year(1i)' => 2016,
    }

    assert_difference 'SalesOrder::Detail.count', -1 do
      assert_difference 'SalesOrder::DetailRow.count', -2 do
        post :destroy_customer_sales, data_import: params
      end
    end
  end

  test "should update product keywords" do
    file = fixture_file_upload 'files/product_keyword_test.xlsx'
    Product::Keyword.delete_all

    assert_difference 'Product::Keyword.count', 3 do
      post :product_keywords, data_import: { file: file }
    end

    assert assigns(:spreadsheet)
    assert_response :success
  end

  test "should update product keywords special information" do
    file = fixture_file_upload 'files/product_keyword_information_test.xlsx'
    Product::Keyword.delete_all

    params = {
      file: file,
      language: 'fi',
      type: 'information'
    }

    assert_difference 'Product::Keyword.count', 2 do
      post :product_information, data_import: params
    end

    assert assigns(:spreadsheet)
    assert_response :success
  end

  test "should update product keywords special parameters" do
    file = fixture_file_upload 'files/product_keyword_parameter_test.xlsx'
    Product::Keyword.delete_all

    params = {
      file: file,
      language: 'fi',
      type: 'parameter'
    }

    # should add 6, remove 2
    assert_difference 'Product::Keyword.count', 4 do
      post :product_information, data_import: params
    end

    assert assigns(:spreadsheet)
    assert_response :success
  end

  test "should get error on a invalid file" do
    post :product_keywords, data_import: { file: '' }
    assert_not_nil flash[:error]
    assert_redirected_to data_import_path
  end

  test "should get error on a invalid file type" do
    file = fixture_file_upload 'files/text_file.txt'

    post :product_keywords, data_import: { file: file }
    assert_not_nil flash[:error]
    assert_redirected_to data_import_path
  end
end
