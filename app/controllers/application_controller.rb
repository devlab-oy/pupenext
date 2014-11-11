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

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def sort_options(column)
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    options = {}
    options['sort'] = column
    options['direction'] = direction
    options['not_used'] = params[:not_used]

    # If controller implements params_search, add search params to sort url
    options.merge! params_search if respond_to? :params_search

    options
  end

  def t(string)
    language = current_user ? current_user.locale : nil
    Dictionary.translate(string, language)
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

    def sort_column
      return params[:sort] if sortable_columns.include? params[:sort].try(:to_sym)

      default_sort_column
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
