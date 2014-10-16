class ApplicationController < ActionController::Base
  include ApplicationHelper

  protect_from_forgery with: :exception

  before_action :authorize
  before_action :set_locale
  before_action :access_control

  protected

    def authorize
      render text: t("Kirjaudu sisään!"), status: :unauthorized unless current_user
    end

    def access_control
      render text: t("Käyttöoikeudet puuttuu!"), status: :forbidden unless read_access?
    end

    def set_locale
      I18n.locale = current_user.locale || I18n.default_locale
    end

end
