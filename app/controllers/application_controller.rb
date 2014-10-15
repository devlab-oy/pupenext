class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  before_action :authorize
  before_action :set_locale

  helper_method :current_user
  helper_method :t
  helper_method :sort_direction

  private

    def current_user
      @current_user ||= User.find_by_session(cookies[:pupesoft_session])
    end

    def t(string)
      language = current_user ? current_user.locale : nil
      Dictionary.translate(string, language)
    end

  protected

    def authorize
      render text: t("Kielletty!"), status: :unauthorized unless current_user
    end

    def set_locale
      I18n.locale = current_user.locale || I18n.default_locale
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end
