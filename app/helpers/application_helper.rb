module ApplicationHelper

  def current_user
    @current_user ||= User.find_by_session(cookies[:pupesoft_session])
  end

  def t(string)
    language = current_user ? current_user.locale : nil
    Dictionary.translate(string, language)
  end

end
