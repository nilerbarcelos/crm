require 'test_helper'

class DocumentsControllerTest < ActionController::TestCase
  
  def test_should_get_index
     get :index, :user_id => users(:one).id
     assert_response :success
     assert_not_nil assigns(:documents)
  end

  def test_should_get_new
    get :new, :user_id => users(:one).id
    assert_response :success
  end

  def test_should_create_document
      assert_difference('Document.count') do
         post :create, :user_id => users(:one).id,
              :document => {:title => "Novo Documento", 
              :doc =>  fixture_file_upload('files/rails.png', 'image/png'),
              :archivable_id => 1, :archivable_type => "User"}
              #:html => { :multipart => true }
      end
      d = "users/#{users(:one).id}/documents/#{Document.last.id}"
      assert_redirected_to d
  end

  def test_should_show_document
    get :show, :user_id => users(:one).id, :id => documents(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :project_id => projects(:one).id, :id => documents(:two).id
    assert_response :success
  end

  def test_should_update_document
    put :update, :user_id => users(:one).id, :id => documents(:one).id, :document => { }
    assert_redirected_to user_document_path(assigns(:document))
  end

  def test_should_destroy_document
    assert_difference('Document.count', -1) do
      delete :destroy, :user_id => users(:one).id, :id => documents(:one).id
   end
    assert_redirected_to user_documents_path
  end
end
