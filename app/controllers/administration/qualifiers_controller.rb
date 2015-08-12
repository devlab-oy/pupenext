class Administration::QualifiersController < AdministrationController
  helper_method :showing_not_used?

  before_action :find_qualifier, only: [:show, :edit, :update]
  before_action :find_isa_options, only: [:new, :show, :create, :edit, :update]

  def index
    q = Qualifier.search_like(search_params).order(order_params)

    if showing_not_used?
      @qualifiers = q.not_in_use
    else
      @qualifiers = q.in_use
    end
  end

  def show
    render :edit
  end

  def edit
  end

  def new
    @qualifier = Qualifier::CostCenter.new
  end

  def create
    @qualifier = Qualifier.new(qualifier_params)

    if @qualifier.save_by current_user
      redirect_to qualifiers_path, notice: t('.create_success')
    else
      render action: :new
    end
  end

  def update
    if @qualifier.update_by(qualifier_params, current_user)
      redirect_to qualifiers_path, notice: t('.update_success')
    else
      render action: :edit
    end
  end

  private

    def find_resource
      @qualifier = Qualifier.find(params[:id])
    end

    def find_isa_options
      @isa_options = Qualifier.in_use.code_name_order
    end

    def find_qualifier
      @qualifier = Qualifier.find(params[:id])
    end

    def showing_not_used?
      params[:not_used] ? true : false
    end

    def qualifier_params
        params.require(:qualifier).permit(
          :nimi,
          :koodi,
          :tyyppi,
          :kaytossa,
          :isa_tarkenne
        )
    end

    def searchable_columns
      [
        :nimi,
        :koodi,
        :tyyppi,
      ]
    end

    def sortable_columns
      searchable_columns
    end
end
