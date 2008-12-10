require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  def test_truth
    assert true
  end

 def test_create_without_user
    get :create
    assert_redirected_to :action => "new" #login_path
    assert_equal "The login/password combination is invalid" , flash[:notice]
 end
 
 def test_login
   diego = users(:one)
   @request.session[:return_to] = 'index'
   post :create, :login => diego.login, :password => "123456"
   assert_redirected_to :action => "index"
   #assert_equal diego.id, session[:user]
 end
end
