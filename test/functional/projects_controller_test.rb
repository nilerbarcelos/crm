require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:projects)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_project
    assert_difference('Project.count') do
      post :create, :project => {
        :name => "Teste Project Email", :description => "Olla", :customer_id => 2,
        :created_at => Time.now, :updated_at => Time.now, :active => false,
        :photo_file_name => "maisa2.jpg", :photo_content_type => "image/jpeg",
        :photo_file_size => 159032, :photo_updated_at => "2008-11-18 18:04:37"
      }
    end

    assert_redirected_to project_path(assigns(:project))
  end

  def test_should_show_project
    get :show, :id => projects(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => projects(:one).id
    assert_response :success
  end

  def test_should_update_project
    put :update, :id => projects(:one).id, :project => { }
    assert_redirected_to project_path(assigns(:project))
  end

  def test_should_destroy_project
    assert_difference('Project.count', -1) do
      delete :destroy, :id => projects(:one).id
    end

    assert_redirected_to projects_path
  end
end
