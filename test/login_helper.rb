module LoginHelper
  def login(user)
    cookies[:pupesoft_session] = user.session

    # Because we dont have SessionController we need to manually set Company.current
    # if we wouldnt do this Company.current would not be set in the beginning of the test eventhough
    # user is allready signed in

    Company.current = user.company
  end

  def logout
    cookies[:pupesoft_session] = nil

    Company.current = nil
  end
end
