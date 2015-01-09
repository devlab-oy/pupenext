class AdministrationController < ApplicationController
  include ColumnSort

  before_action :update_access, only: [:new, :create, :update, :destroy]
  before_action :find_resource, only: [:show, :edit, :update, :destroy]

  def update_access
    render text: t("Käyttöoikeudet puuttuu!"), status: :forbidden unless update_access?
  end
end
