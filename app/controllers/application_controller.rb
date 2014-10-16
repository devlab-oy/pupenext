class ApplicationController < ActionController::Base
  include ApplicationHelper

  protect_from_forgery with: :exception

  before_action :authorize
  before_action :set_locale

  protected

    def authorize
      render text: t("Kielletty!"), status: :unauthorized unless current_user
    end

    def set_locale
      I18n.locale = current_user.locale || I18n.default_locale
    end

end
