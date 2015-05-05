class HomeController < ApplicationController

  def index
    render nothing: true
  end

  def test
    # This action is used only to test access control
    # Can be removed once we have some actual routes to test on
    render nothing: true
  end

end
