module LoginHelper
  def login(user)
    cookies[:pupesoft_session] = user.session
    Company.current = user.company
  end

  def logout
    cookies[:pupesoft_session] = nil
    Company.current = nil
  end
end
