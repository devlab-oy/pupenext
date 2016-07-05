class CategoriesController < ApplicationController
  protect_from_forgery with: :null_session

  skip_before_action :authorize,     :set_current_info, :set_locale, :access_control
  before_action      :api_authorize, :set_current_info, :set_locale, :access_control

  def read_access?
    @read_access ||= current_user.can_read?('/categories', alias_set: alias_set)
  end

  def update_access?
    @update_access ||= current_user.can_update?('/categories', alias_set: alias_set)
  end
end
