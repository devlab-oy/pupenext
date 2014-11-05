module ApplicationHelper
  PER_PAGE=10
  
  def current_user
    @current_user ||= User.find_by_session(cookies[:pupesoft_session])
  end

  def current_company
    @current_company ||= current_user.company
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def sortable(column)
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    options = {}
    options['sort'] = column
    options['direction'] = direction
    options['not_used'] = params[:not_used]

    # If controller implements params_search, add search params to sort url
    options.merge! params_search if respond_to? :params_search

    link_to column, options
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

end
