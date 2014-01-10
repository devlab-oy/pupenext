class ApplicationController < ActionController::Base
  include Translatable

  protect_from_forgery with: :exception

  before_action :authorize
  before_action :set_current_company
  before_action :set_locale
  before_action :access_control

  helper_method :current_user
  helper_method :current_company
  helper_method :update_access?
  helper_method :t

  def current_user
    @current_user ||= User.unscoped.find_by_session(cookies[:pupesoft_session])
  end

  def set_current_company
    Current.company = current_user.company
  end

  def read_access?
    # Root path does not require access
    return true if request_path == root_path

    @read_access ||= current_user.can_read?(request_path)
  end

  def update_access?
    @update_access ||= current_user.can_update?(request_path)
  end

    def t(string)
      language = current_user ? current_user.kieli : nil
      Dictionary.translate(string, language)
    end

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

  private

    def request_path
      # return first resource from request, our access control is based on it
      path = request.path_info.split '/'

      access = '/'
      access << path.second unless path.empty?
      access
    end
end
