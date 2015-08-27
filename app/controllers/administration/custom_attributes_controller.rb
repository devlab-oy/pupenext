class Administration::CustomAttributesController < AdministrationController
  before_action :redirect_to_show_set, only: :index

  def index
  end

  def show_set
    @attribute_set = Keyword::CustomAttribute.fetch_set set_parameters
  end

  private

    def redirect_to_show_set
      return unless set_parameters[:table_name].present? && set_parameters[:set_name].present?

      redirect_to action: :show_set,
        table_name: set_parameters[:table_name],
        set_name: set_parameters[:set_name]
    end

    def set_parameters
      allowed = params.permit(:table_name, :set_name).symbolize_keys

      if params[:combo_name].present?
        allowed[:table_name] = params[:combo_name].split('/').first
        allowed[:set_name]   = params[:combo_name].split('/').last
      end

      allowed
    end
end
