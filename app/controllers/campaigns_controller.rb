class CampaignsController < ApplicationController
  include ColumnSort
  helper_method :show_inactive?
  before_action :find_resource, only: [:update, :edit]

  def index
    visible_campaigns = show_inactive? ? Campaign.all : Campaign.active
    @campaigns = visible_campaigns.search_like(search_params).order(order_params)
  end

  def new
    @campaign = Campaign.new
    render :edit
  end

  def edit
  end

  def create
    @campaign = Campaign.new campaign_params

    if @campaign.save
      redirect_to campaigns_path, notice: t('.create_success')
    else
      render :edit
    end
  end

  def update
    if @campaign.update campaign_params
      redirect_to campaigns_path, notice: t('.update_success')
    else
      render :edit
    end
  end

  private
     
    def show_inactive?
      params[:show_inactive] == "yes"
    end

    def find_resource
      @campaign = Campaign.find params[:id]
    end

    def campaign_params
      params.require(:campaign).permit(
        :id,
        :name,
        :description,
        :active
      )
    end

    def searchable_columns
      [:name, :description, :active]
    end

    def sortable_columns
      searchable_columns
    end
end
