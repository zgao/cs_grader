require 'test_helper'

class CsClassesControllerTest < ActionController::TestCase
  setup do
    @cs_class = cs_classes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cs_classes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cs_class" do
    assert_difference('CsClass.count') do
      post :create, cs_class: {  }
    end

    assert_redirected_to cs_class_path(assigns(:cs_class))
  end

  test "should show cs_class" do
    get :show, id: @cs_class
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @cs_class
    assert_response :success
  end

  test "should update cs_class" do
    put :update, id: @cs_class, cs_class: {  }
    assert_redirected_to cs_class_path(assigns(:cs_class))
  end

  test "should destroy cs_class" do
    assert_difference('CsClass.count', -1) do
      delete :destroy, id: @cs_class
    end

    assert_redirected_to cs_classes_path
  end
end
