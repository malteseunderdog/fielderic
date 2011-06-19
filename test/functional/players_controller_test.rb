require 'test_helper'

class PlayersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:player)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create player" do
    assert_difference('Player.count') do
      post :create, :player => { }
    end

    assert_redirected_to player_path(assigns(:player))
  end

  test "should show player" do
    get :show, :id => player(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => player(:one).to_param
    assert_response :success
  end

  test "should update player" do
    put :update, :id => player(:one).to_param, :player => { }
    assert_redirected_to player_path(assigns(:player))
  end

  test "should destroy player" do
    assert_difference('Player.count', -1) do
      delete :destroy, :id => player(:one).to_param
    end

    assert_redirected_to player_path
  end
end
