class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  before_action :authorize
  before_action :set_locale

  helper_method :current_user
  helper_method :t

  private

    def current_user
      @current_user ||= User.find_by_session(cookies[:pupesoft_session])
    end

    def t(string)
      language = current_user ? current_user.kieli : nil
      Dictionary.translate(string, language)
    end

  protected

    def authorize
      render text: t("Kielletty!"), status: :unauthorized unless current_user
    end

    def set_locale
      I18n.locale = current_user.kieli || I18n.default_locale
    end

end
