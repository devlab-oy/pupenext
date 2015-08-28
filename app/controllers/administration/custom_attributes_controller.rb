class Administration::CustomAttributesController < AdministrationController
  def index
    set = Keyword::CustomAttribute.all
    set = set.fetch_set combo_params if combo_params

    @attribute_set = set.order(:set_name, :database_field)
  end

  def edit
  end

  def show
    render :edit
  end

  private

    def find_resource
      @custom_attribute = Keyword::CustomAttribute.find params[:id]
    end

    def combo_params
      return unless params[:combo_set].present?

      table_name = params[:combo_set].split('/').first
      set_name   = params[:combo_set].split('/').last

      { table_name: table_name, set_name: set_name }
    end
end
