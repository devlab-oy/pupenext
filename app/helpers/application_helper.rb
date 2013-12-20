module ApplicationHelper

  def current_user
    @current_user ||= User.find_by_session(cookies[:pupesoft_session])
  end

end
