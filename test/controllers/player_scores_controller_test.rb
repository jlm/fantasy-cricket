require 'test_helper'

class PlayerScoresControllerTest < ActionController::TestCase
  setup do
    @player_score = player_scores(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:player_scores)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create player_score" do
    assert_difference('PlayerScore.count') do
      post :create, player_score: { bat_balls: @player_score.bat_balls, bat_fours: @player_score.bat_fours, bat_how: @player_score.bat_how, bat_minutes: @player_score.bat_minutes, bat_runs_scored: @player_score.bat_runs_scored, bat_sixes: @player_score.bat_sixes, bat_sr: @player_score.bat_sr, bowl_er: @player_score.bowl_er, bowl_maidens: @player_score.bowl_maidens, bowl_noballs: @player_score.bowl_noballs, bowl_overs: @player_score.bowl_overs, bowl_runs: @player_score.bowl_runs, bowl_wickets: @player_score.bowl_wickets, bowl_wides: @player_score.bowl_wides, field_catches: @player_score.field_catches, field_runouts: @player_score.field_runouts, field_stumpings: @player_score.field_stumpings, innings_id: @player_score.innings_id, match_id: @player_score.match_id, name: @player_score.name }
    end

    assert_redirected_to player_score_path(assigns(:player_score))
  end

  test "should show player_score" do
    get :show, id: @player_score
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @player_score
    assert_response :success
  end

  test "should update player_score" do
    patch :update, id: @player_score, player_score: { bat_balls: @player_score.bat_balls, bat_fours: @player_score.bat_fours, bat_how: @player_score.bat_how, bat_minutes: @player_score.bat_minutes, bat_runs_scored: @player_score.bat_runs_scored, bat_sixes: @player_score.bat_sixes, bat_sr: @player_score.bat_sr, bowl_er: @player_score.bowl_er, bowl_maidens: @player_score.bowl_maidens, bowl_noballs: @player_score.bowl_noballs, bowl_overs: @player_score.bowl_overs, bowl_runs: @player_score.bowl_runs, bowl_wickets: @player_score.bowl_wickets, bowl_wides: @player_score.bowl_wides, field_catches: @player_score.field_catches, field_runouts: @player_score.field_runouts, field_stumpings: @player_score.field_stumpings, innings_id: @player_score.innings_id, match_id: @player_score.match_id, name: @player_score.name }
    assert_redirected_to player_score_path(assigns(:player_score))
  end

  test "should destroy player_score" do
    assert_difference('PlayerScore.count', -1) do
      delete :destroy, id: @player_score
    end

    assert_redirected_to player_scores_path
  end
end
