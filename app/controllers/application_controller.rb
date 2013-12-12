class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :authorize

  private

    def current_user
      @current_user ||= User.find_by_session(cookies[:pupesoft_session])
    end

  protected

    def authorize
      render text: "Forbidden!", status: :unauthorized unless current_user
    end

end
