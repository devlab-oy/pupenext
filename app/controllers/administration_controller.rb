class AdministrationController < ApplicationController
  include ColumnSort

  before_action :update_access, only: [:new, :create, :update, :destroy]
  before_action :find_resource, only: [:show, :edit, :update, :destroy]

  def update_access
    render text: t('.forbidden'), status: :forbidden unless update_access?
  end

  def resource_parameters(model:, parameters:)
    alias_set  = params[:alias_set].to_s
    set_name   = alias_set.empty? ? "Default" : alias_set
    table_name = model.to_s.classify.constantize.table_name
    attributes = Keyword::CustomAttribute.fetch_set table_name: table_name, set_name: set_name

    allowed = attributes.present? ? attributes.visible.map { |a| a.field.to_sym }.sort : parameters

    params.require(model).permit(allowed)
  end
end
