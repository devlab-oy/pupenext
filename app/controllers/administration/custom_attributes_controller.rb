class Administration::CustomAttributesController < AdministrationController
  def index
    @attribute_set = Keyword::CustomAttribute.fetch_set(alias_set_params)
      .order(:set_name, :database_field)
  end

  def new
    @custom_attribute = Keyword::CustomAttribute.new
    @custom_attribute.set_name = alias_set_params[:set_name]

    render :edit
  end

  def edit
  end

  def show
    render :edit
  end

  def create
    @custom_attribute = Keyword::CustomAttribute.new custom_keyword_params

    if @custom_attribute.save
      redirect_to custom_attributes_path(table_alias_set: @custom_attribute.alias_set_name)
    else
      render :edit
    end
  end

  def update
    if @custom_attribute.update custom_keyword_params
      redirect_to custom_attributes_path(table_alias_set: @custom_attribute.alias_set_name)
    else
      render :edit
    end
  end

  def destroy
    @custom_attribute.destroy
    redirect_to custom_attributes_path(table_alias_set: @custom_attribute.alias_set_name)
  end

  private

    def find_resource
      @custom_attribute = Keyword::CustomAttribute.find params[:id]
    end

    def alias_set_params
      table_name, set_name = params[:table_alias_set].to_s.split('+')

      { table_name: table_name, set_name: set_name }
    end

    def custom_keyword_params
      params.require(:custom_attribute).permit(
        :database_field,
        :default_value,
        :help_text,
        :label,
        :required,
        :set_name,
        :visibility,
      )
    end
end
