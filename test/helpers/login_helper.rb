module LoginHelper
  def login(user)
    cookies[:pupesoft_session] = user.session
  end

  def logout
    cookies[:pupesoft_session] = nil
  end
end
