class CategoriesController < ApplicationController
  protect_from_forgery with: :null_session

  skip_before_action :authorize,     :set_current_info, :set_locale, :access_control
  before_action      :api_authorize, :set_current_info, :set_locale, :access_control
end
