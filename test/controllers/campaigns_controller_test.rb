require 'test_helper'

class CampaignsControllerTest < ActionController::TestCase
  fixtures %w(campaigns)

  setup do
    login users(:bob)
    @campaign = campaigns(:galna)
    @valid_params = {
      name: 'The very first campaign',
      description: 'Inactive campaign from the past',
      active: false,
    }
  end

  test 'fixtures should be valid' do
    assert @campaign.valid?
  end

  test 'should get index' do
    get :index
    assert_response :success
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @campaign
    assert_response :success
  end

  test "should create campaign" do
    assert_difference('Campaign.count') do
      post :create, campaign: @valid_params
    end

    assert_redirected_to campaigns_path
    campaign = Campaign.last

    assert_equal @valid_params[:name],        campaign.name
    assert_equal @valid_params[:description], campaign.description
    assert_equal @valid_params[:active],      campaign.active
  end

  test "should update campaign" do
    patch :update, id: @campaign, campaign: @valid_params
    assert_redirected_to campaigns_path

    @campaign.reload

    assert_equal @valid_params[:name],        @campaign.name
    assert_equal @valid_params[:description], @campaign.description
    assert_equal @valid_params[:active],      @campaign.active
  end
end
