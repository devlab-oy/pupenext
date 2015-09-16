class Administration::QualifiersController < AdministrationController
  helper_method :showing_not_used?

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
    @qualifier = Qualifier.new
    render :edit
  end

  def create
    @qualifier = Qualifier.new qualifier_params

    if @qualifier.save
      redirect_to qualifiers_path, notice: t('.create_success')
    else
      render :edit
    end
  end

  def update
    if @qualifier.update qualifier_params
      redirect_to qualifiers_path, notice: t('.update_success')
    else
      render :edit
    end
  end

  private

    def find_resource
      @qualifier = Qualifier.find params[:id]
    end

    def showing_not_used?
      params[:not_used] ? true : false
    end

    def qualifier_params
      resource_parameters model: :qualifier, parameters: [
        :nimi,
        :koodi,
        :tyyppi,
        :kaytossa,
        :isa_tarkenne,
      ]
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
