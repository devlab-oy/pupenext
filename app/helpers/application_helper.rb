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

  def sortable(column_name)
    link_to column_name, sort_options(column_name)
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

  def firefox?
    user_agent_include? "firefox"
  end

  def trident?
    user_agent_include? "trident"
  end

  def chrome?
    user_agent_include? "chrome"
  end

  def windows?
    user_agent_include? "windows"
  end

  private

    def request_path
      # return first resource from request, our access control is based on it
      path = request.path_info.split '/'

      access = '/'
      access << path.second unless path.empty?
      access
    end

    def user_agent_include?(value)
      request.user_agent.downcase.include? value.to_s.downcase
    end

end
