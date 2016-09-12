require 'test_helper'

class PendingProductUpdatesControllerTest < ActionController::TestCase
  fixtures %w(
    pending_updates
    product/suppliers
    products
    suppliers
  )

  setup do
    login users(:joe)

    @product = products :hammer
    @pending = pending_updates :update_1
  end

  test 'should get index' do
    get :index
    assert_response :success

    assert_template :index, "Template should be index"
  end

  test 'should get list of products' do
    get :list
    assert_response :success
    assert_template :index, "Without pressing submit-button template should be index"
    assert_nil assigns(:products)

    get :list, commit: 'search'
    assert_template :list, "By pressing submit-button template should be list"
    assert_not_nil assigns(:products)

    get :list, { commit: 'search', hinta: 'myymalahinta' }
    assert_template :list, "By selecting price template should be list"
    assert_not_nil assigns(:products)
    assert_select "td", { text: '315,00 €', count: 1 }

    get :list, { commit: 'search', 'tuotteen_toimittajat.toim_tuoteno' => 'masterhammer' }
    assert_select "td", { text: 'hammer123', count: 1 }
  end

  test 'should get only a list of products with upcoming changes' do
    get :list_of_changes
    assert_response :success
    assert_template :list, "should render list-view when having products with pending updates"
  end

  test 'should redirect to index if there are no products with upcoming changes' do
    PendingUpdate.delete_all
    get :list_of_changes
    assert_redirected_to pending_product_updates_path, "should redirect to index when there are no products with pending updates"
  end

  test 'should move pending updates to product' do
    hammer = products :hammer
    helmet = products :helmet

    @pending.dup.update_attributes! key: 'nimitys', value: 'sledge'
    @pending.dup.update_attributes! pending_updatable_id: helmet.id, key: 'nimitys', value: 'sledge2'

    assert_difference 'PendingUpdate.count', -3 do
      post :to_product, { pending_update:  { product_ids: [hammer.id, helmet.id] } }
    end

    assert_equal 100.5, hammer.reload.myyntihinta
    assert_equal 'sledge', hammer.nimitys
    assert_equal 'sledge2', helmet.reload.nimitys
    assert_redirected_to pending_product_updates_path, "should render index-view after moving pending updates to product"
  end

  test 'should not move pending updates to product and should get failed count and error messages' do
    hammer = products :hammer
    helmet = products :helmet

    @pending.update_columns key: 'nimitys', value: ''

    assert_difference 'PendingUpdate.count', 0 do
      post :to_product, { pending_update:  { product_ids: [hammer.id, helmet.id] } }
    end

    assert_equal 'All-around hammer', hammer.reload.nimitys
    assert_match /Nimitys ei voi olla tyhjä/, flash[:notice]
    assert_redirected_to pending_product_updates_path, "should render index-view after moving pending updates to product"
  end

  test "should create pending update" do
    params = {
      pending_updates_attributes: [
        { key: 'kuvaus', value: 'foo' },
        { key: 'nimitys', value: '123.0' },
      ]
    }

    assert_difference 'PendingUpdate.count', 2 do
      xhr :patch, :update, id: @product.id, product: params, format: :js
      assert_response :success
      assert_template partial: 'update', count: 0
    end

    assert_equal 'nimitys', @product.pending_updates.last.key
    assert_equal '123.0', @product.pending_updates.last.value
  end

  test "should update pending update" do
    params = {
      pending_updates_attributes: [
        { id: @pending.id, key: 'myyntihinta', value: '50.1' }
      ]
    }

    assert_no_difference 'PendingUpdate.count' do
      xhr :patch, :update, id: @product.id, product: params, format: :js
      assert_response :success
      assert_template partial: 'update', count: 0
    end

    assert_equal '50.1', @pending.reload.value
  end

  test "should destroy pending update" do
    params = {
      pending_updates_attributes: [
        { id: @pending.id, _destroy: true }
      ]
    }

    assert_difference 'PendingUpdate.count', -1 do
      xhr :patch, :update, id: @product.id, product: params, format: :js
      assert_response :success
      assert_template partial: 'update', count: 0
    end
  end

  test "make sure we have the needed elemets for updating with javascript" do
    get :list, commit: 'search'

    product = products :hammer

    text = I18n.t 'pending_product_updates.form.link_new'
    assert_select 'a[data-association=pending_update]', { minimum: 1, html: text }, 'form must have data-association link'

    assert_select "td[class='ptop pending_update']", { minimum: 1 }, 'must have pending update td'
    assert_select 'div[class=nested-fields]', { minimum: 1 }, 'must have nested-fields div'
    assert_select 'div[class=notifications]', { minimum: 1 }, 'must have notifications div'
    assert_select "div[id=pending_updates_#{product.id}]", { minimum: 1 }, 'must have product pending updates div'
  end
end
