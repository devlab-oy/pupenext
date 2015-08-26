require 'test_helper'

# The purpose of AdministrationControllerTest is to test the common logic behind AdministrationController
class ApplicationControllerTest < ActionController::TestCase
  tests Administration::AccountsController
  fixtures %w(users companies)

  setup do
    @user = users(:bob)
    login users(:bob)
  end

  test 'test current company' do
    get :index

    assigns(:accounts).each do |account|
      assert_equal @user.company.id, account.company.id
    end
  end
end
