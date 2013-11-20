require 'test_helper'

class InningsControllerTest < ActionController::TestCase
  setup do
    @innings = innings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:innings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create innings" do
    assert_difference('Innings.count') do
      post :create, innings: { date: @innings.date, innings_id: @innings.innings_id, inningsname: @innings.inningsname, matchname: @innings.matchname }
    end

    assert_redirected_to innings_path(assigns(:innings))
  end

  test "should show innings" do
    get :show, id: @innings
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @innings
    assert_response :success
  end

  test "should update innings" do
    patch :update, id: @innings, innings: { date: @innings.date, innings_id: @innings.innings_id, inningsname: @innings.inningsname, matchname: @innings.matchname }
    assert_redirected_to innings_path(assigns(:innings))
  end

  test "should destroy innings" do
    assert_difference('Innings.count', -1) do
      delete :destroy, id: @innings
    end

    assert_redirected_to innings_index_path
  end
end
