class Administration::CustomAttributesController < AdministrationController
  before_action :search_set, only: :index

  def index
  end

  private

    def search_set
      set = params[:custom_attributes] ? params[:custom_attributes][:set_name] : nil
      @attribute_set = Keyword::CustomAttribute.where(set_name: set) if set.present?
    end
end
