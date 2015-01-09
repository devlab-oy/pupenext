class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authorize
  before_action :set_locale
  before_action :access_control

  helper_method :sort_options
  helper_method :update_access?
  helper_method :current_user
  helper_method :t

  def current_user
    @current_user ||= User.find_by_session(cookies[:pupesoft_session])
  end

  def current_company
    @current_company ||= current_user.company
  end

  def t(string)
    Dictionary.translate(string, I18n.locale.to_s)
  end

  def read_access?
    # Root path does not require access
    return true if request_path == root_path

    current_user.can_read? request_path
  end

  def update_access?
    current_user.can_update? request_path
  end

  private
    def request_path
      # return first resource from request, our access control is based on it
      path = request.path_info.split '/'

      access = '/'
      access << path.second unless path.empty?
      access
    end

    def filter_search_params
      p = params.permit(searchable_columns)

      p.reject { |_, v| v.empty? }
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
end
