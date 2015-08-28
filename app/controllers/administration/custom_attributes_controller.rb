class Administration::CustomAttributesController < AdministrationController
  def index
    set = Keyword::CustomAttribute.all
    set = set.fetch_set combo_params if combo_params

    @attribute_set = set.order(:selite)
  end

  private

    def combo_params
      return unless params[:combo_set].present?

      table_name = params[:combo_set].split('/').first
      set_name   = params[:combo_set].split('/').last

      { table_name: table_name, set_name: set_name }
    end
end
