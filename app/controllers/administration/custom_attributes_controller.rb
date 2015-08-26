class Administration::CustomAttributesController < AdministrationController
  before_action :search_set, only: :index

  def index
  end

  private

    def search_set
      @set_name = params[:custom_attributes] ? params[:custom_attributes][:set_name] : nil
      @attribute_set = Keyword::CustomAttribute.where(set_name: @set_name) if @set_name.present?
    end
end
