class Administration::QualifiersController < AdministrationController
  helper_method :showing_not_used?

  before_action :find_qualifier, only: [:show, :edit, :update]
  before_action :find_isa_options, only: [:new, :show, :create, :edit, :update]

  def index
    q = current_company.qualifiers

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
    @qualifier = current_company.cost_centers.build
  end

  def create
    @qualifier = current_company.qualifiers.build(qualifier_params)

    if @qualifier.save_by current_user
      redirect_to qualifiers_path, notice: t("Tarkenne luotiin onnistuneesti")
    else
      render action: :new
    end
  end

  def update
    if @qualifier.update_by(qualifier_params, current_user)
      redirect_to qualifiers_path, notice: t("Tarkenne päivitettiin onnistuneesti")
    else
      render action: :edit
    end
  end

  private

    def find_resource
      @qualifier = current_company.qualifiers.find(params[:id])
    end

    def find_isa_options
      @isa_options = current_company.qualifiers
    end

    def find_qualifier
      @qualifier = current_company.qualifiers.find(params[:id])
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
end
