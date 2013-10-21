require 'test_helper'

class PlayersControllerTest < ActionController::TestCase
  setup do
    @player = players(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:players)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create player" do
    assert_difference('Player.count') do
      post :create, player: { age_category: @player.age_category, bat_ducks: @player.bat_ducks, bat_fifties: @player.bat_fifties, bat_hundreds: @player.bat_hundreds, bat_innings: @player.bat_innings, bat_not_outs: @player.bat_not_outs, bat_runs_scored: @player.bat_runs_scored, bowl_4_wickets: @player.bowl_4_wickets, bowl_6_wickets: @player.bowl_6_wickets, bowl_overs: @player.bowl_overs, bowl_runs: @player.bowl_runs, bowl_wickets: @player.bowl_wickets, field_catches: @player.field_catches, field_drops: @player.field_drops, field_mom: @player.field_mom, field_runouts: @player.field_runouts, field_stumpings: @player.field_stumpings, name: @player.name }
    end

    assert_redirected_to player_path(assigns(:player))
  end

  test "should show player" do
    get :show, id: @player
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @player
    assert_response :success
  end

  test "should update player" do
    patch :update, id: @player, player: { age_category: @player.age_category, bat_ducks: @player.bat_ducks, bat_fifties: @player.bat_fifties, bat_hundreds: @player.bat_hundreds, bat_innings: @player.bat_innings, bat_not_outs: @player.bat_not_outs, bat_runs_scored: @player.bat_runs_scored, bowl_4_wickets: @player.bowl_4_wickets, bowl_6_wickets: @player.bowl_6_wickets, bowl_overs: @player.bowl_overs, bowl_runs: @player.bowl_runs, bowl_wickets: @player.bowl_wickets, field_catches: @player.field_catches, field_drops: @player.field_drops, field_mom: @player.field_mom, field_runouts: @player.field_runouts, field_stumpings: @player.field_stumpings, name: @player.name }
    assert_redirected_to player_path(assigns(:player))
  end

  test "should destroy player" do
    assert_difference('Player.count', -1) do
      delete :destroy, id: @player
    end

    assert_redirected_to players_path
  end
end
