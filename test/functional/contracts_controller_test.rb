require 'test_helper'

class ContractsControllerTest < ActionController::TestCase

  def setup
   super
    @request.session[:user] = users(:one).id
  end


  def test_index_with_user
   #@request.session[:user] = users(:one).id
   get :index #, {}, {:user => users(:one).id }
   assert_response :success
   assert_template "index"
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:contracts)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_contract
    assert_difference('Contract.count') do
      post :create, :contract => { 
       :name => "Contrato de Teste", :code => "RUBY", :description => "Teste de Contrato",
       :status => "accepted", :started_at => Time.now, :ended_at => nil, :value => 50.0, 
       :leader_id => 3, :project_id => 6, :created_at => Time.now, :updated_at => "2008-11-15 16:21:19"
      }
    end

    assert_redirected_to contract_path(assigns(:contract))
  end

  def test_should_show_contract
    get :show, :id => contracts(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => contracts(:one).id
    assert_response :success
  end

  def test_should_update_contract
    put :update, :id => contracts(:one).id, :contract => { }
    assert_redirected_to contract_path(assigns(:contract))
  end

  def test_should_destroy_contract
    assert_difference('Contract.count', -1) do
      delete :destroy, :id => contracts(:one).id
    end

    assert_redirected_to contracts_path
  end
end
