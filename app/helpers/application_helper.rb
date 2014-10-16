module ApplicationHelper

  def current_user
    @current_user ||= User.find_by_session(cookies[:pupesoft_session])
  end

  def t(string)
    language = current_user ? current_user.locale : nil
    Dictionary.translate(string, language)
  end

  def read_access?
    # Root path does noe require access
    return true if request_path == root_path

    current_user.can_read? request_path
  end

  def update_access?
    current_user.can_update? request_path
  end

  private

    def request_path
      # return request path without parameters
      request.fullpath.split('?').first
    end

end
