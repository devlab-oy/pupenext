class ApplicationController < ActionController::Base

  include ApplicationHelper

  protect_from_forgery with: :exception
  before_filter :authorize

  protected

    def authorize
      render text: "Forbidden!", status: :unauthorized unless current_user
    end

end
