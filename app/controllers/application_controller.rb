class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authorize
  before_action :set_current_info
  before_action :set_locale
  before_action :access_control

  helper_method :current_user
  helper_method :current_company
  helper_method :update_access?

  def current_user
    @current_user ||= User.unscoped.find_by_session(cookies[:pupesoft_session])
  end

  def current_company
    @current_company ||= current_user.company
  end

  def set_current_info
    Current.user = current_user
    Current.company = current_user.company
  end

  def read_access?
    # Root path does not require access
    return true if request_path == root_path

    @read_access ||= current_user.can_read?(request_path, alias_set: alias_set)
  end

  def update_access?
    @update_access ||= current_user.can_update?(request_path, alias_set: alias_set)
  end

  protected

    def authorize
      render text: t('application.authorize.unauthorized'), status: :unauthorized unless current_user
    end

    def access_control
      render text: t('application.access_control.forbidden'), status: :forbidden unless read_access?
    end

    def set_locale
      I18n.locale = params_locale ||
                    users_locale ||
                    I18n.default_locale
    end

  private

    def request_path
      # return first resource from request, our access control is based on it
      path = request.path_info.split '/'

      access = '/'
      access << path.second unless path.empty?
      access
    end

    def users_locale
      case current_user.locale
      when "se"
        "sv"
      when "ee"
        "et"
      when "dk"
        "da"
      else
        current_user.locale
      end
    end

    def params_locale
      locale = params[:locale].to_s.downcase

      if available_locales.include?(locale)
        locale
      else
        nil
      end
    end

    def available_locales
      I18n.available_locales.map(&:to_s)
    end

    def default_url_options(options = {})
      if alias_set.present?
        { alias_set: alias_set }.merge options
      else
        options
      end
    end

    def alias_set
      params[:alias_set].to_s
    end

    def api_authorize
      @current_user = User.unscoped.find_by_api_key(params[:access_token])
      head :unauthorized unless @current_user
    end
end
