class AdministrationController < ApplicationController
  include ColumnSort

  before_action :update_access, only: [:new, :create, :update, :destroy]
  before_action :find_resource, only: [:show, :edit, :update, :destroy]

  def update_access
    render text: t('.forbidden'), status: :forbidden unless update_access?
  end

  def resource_parameters(klass, *strong_parameters)
    alias_set  = params[:alias_set].to_s
    set_name   = alias_set.empty? ? "Default" : alias_set
    table_name = klass.table_name
    attributes = Keyword::CustomAttribute.visible.fetch_set table_name: table_name, set_name: set_name

    return strong_parameters unless attributes.present?

    attributes.map { |a| a.field.to_sym }
  end
end
