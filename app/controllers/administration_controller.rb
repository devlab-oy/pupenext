class AdministrationController < ApplicationController
  before_action :update_access, only: [:new, :create, :update, :destroy]
  before_action :find_resource, only: [:show, :edit, :update, :destroy]

  def update_access
    msg = "Sinulla ei ole päivitysoikeuksia"
    redirect_to no_update_access_path, notice: msg unless update_access?
  end
end
