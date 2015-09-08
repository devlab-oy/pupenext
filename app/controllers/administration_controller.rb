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
    resource_parameters = params.require(model).permit(allowed)

    resource_parameters.merge! default_values_for_hidden(attributes) if is_a_new_resource?
    resource_parameters
  end

  private

    def default_values_for_hidden(attributes)
      params = {}

      attributes.hidden.where.not(default_value: '').each do |attr|
        params[attr.field.to_sym] = attr.default_value
      end

      ActionController::Parameters.new params
    end

    def is_a_new_resource?
      params[:id].blank?
    end
end
