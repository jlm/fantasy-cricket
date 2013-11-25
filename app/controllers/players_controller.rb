class PlayersController < ApplicationController
  before_action :set_player, only: [:show, :edit, :update, :destroy]
  before_action :admin_user, only: [:new, :create, :edit, :update, :destroy]

  helper_method :sort_column, :sort_direction
  
  # GET /players
  # GET /players.json
  def index
    @players = Player.order(sort_column + " " + sort_direction).paginate(page: params[:page], per_page: 10)
  end

  # GET /players/1
  # GET /players/1.json
  def show
  end

  # GET /players/new
  def new
    @player = Player.new
    @player.name = params[:name]
    @player.age_category = params[:age_category]
  end

  # GET /players/1/edit
  def edit
  end

  # POST /players
  # POST /players.json
  def create
    @player = Player.new(player_params)
    # I think the next line contains an SQL injection risk without player_params.
    @player.total = INITIAL_PLAYER_PRICES[player_params[:team].to_i]
    @player.field_mom = @player.field_mom.to_i

    respond_to do |format|
      if @player.save
        format.html { redirect_to @player, notice: 'Player was successfully created.' }
        format.json { render action: 'show', status: :created, location: @player }
      else
        format.html { render action: 'new' }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /players/1
  # PATCH/PUT /players/1.json
  def update
    respond_to do |format|
      if @player.update(player_params)
        format.html { redirect_to @player, notice: 'Player was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /players/1
  # DELETE /players/1.json
  def destroy
    @player.destroy
    respond_to do |format|
      format.html { redirect_to players_url }
      format.json { head :no_content }
    end
  end

  def apply_player_score
    @player = Player.find(params[:id])
    @player_score = PlayerScore.find(params[:player_score_id])
    @innings = @player_score.innings
    @match = @innings.match
    #binding.pry
    if @player.player_scores.exists?(:id => @player_score.id)
      redirect_to match_innings_player_scores_url(@match, @innings), notice: "Player #{@player.name} already has this player score applied"
    else
      @player.player_scores << @player_score

      runs = @player_score.bat_runs_scored.to_i
      centuries = runs / 100
      fifties = (runs - centuries * 100) / 50
      @player.bat_hundreds = @player.bat_hundreds.to_i + centuries
      @player.bat_fifties = @player.bat_fifties.to_i + fifties
      @player.bat_ducks = @player.bat_ducks.to_i + 1 if !@player_score.bat_runs_scored.nil? and @player_score.bat_runs_scored.to_i == 0
      @player.bat_runs_scored = @player.bat_runs_scored.to_i + @player_score.bat_runs_scored.to_i
      @player.bat_not_outs = @player.bat_not_outs.to_i + @player_score.bat_not_outs.to_i
      @player.bat_fours = @player.bat_fours.to_i + @player_score.bat_fours.to_i
      @player.bat_sixes = @player.bat_sixes.to_i + @player_score.bat_sixes.to_i

      wickets = @player_score.bowl_wickets.to_i
      six_wickets = wickets / 6
      four_wickets = (wickets - six_wickets * 6) / 4
      @player.bowl_overs = @player.bowl_overs.to_i + @player_score.bowl_overs.to_i
      @player.bowl_maidens = @player.bowl_maidens.to_i + @player_score.bowl_maidens.to_i
      @player.bowl_runs = @player.bowl_runs.to_i + @player_score.bowl_runs.to_i
      @player.bowl_wickets = @player.bowl_wickets.to_i + wickets
      @player.bowl_4_wickets = @player.bowl_4_wickets.to_i + four_wickets
      @player.bowl_6_wickets = @player.bowl_6_wickets.to_i + six_wickets

      @player.field_catches = @player.field_catches.to_i + @player_score.field_catches.to_i
      @player.field_runouts = @player.field_runouts.to_i + @player_score.field_runouts.to_i
      @player.field_stumpings = @player.field_stumpings.to_i + @player_score.field_stumpings.to_i
      @player.field_drops = @player.field_drops.to_i + @player_score.field_drops.to_i

      @player.field_mom = @player.field_mom.to_i + 1 if @player_score.innings.match.mom = @player.id
      @player.save

      flash[:success] = "New player score attached to Player #{@player.name}"
      redirect_to match_innings_player_scores_url(@match, @innings)
    end
  end

  def unapply_player_score
    @player = Player.find(params[:id])
    @player_score = PlayerScore.find(params[:player_score_id])
    @innings = @player_score.innings
    @match = @innings.match
    #binding.pry
    if !@player.player_scores.exists?(:id => @player_score.id)
      redirect_to match_innings_player_scores_url(@match, @innings), notice: "Player #{@player.name} does not have this player score applied"
    else
      @player.player_scores.delete(@player_score)

      runs = @player_score.bat_runs_scored.to_i
      centuries = runs / 100
      fifties = (runs - centuries * 100) / 50
      @player.bat_hundreds = @player.bat_hundreds.to_i - centuries
      @player.bat_fifties = @player.bat_fifties.to_i - fifties
      @player.bat_ducks = @player.bat_ducks.to_i - 1 if !@player_score.bat_runs_scored.nil? and @player_score.bat_runs_scored.to_i == 0
      @player.bat_runs_scored = @player.bat_runs_scored.to_i - @player_score.bat_runs_scored.to_i
      @player.bat_not_outs = @player.bat_not_outs.to_i - @player_score.bat_not_outs.to_i
      @player.bat_fours = @player.bat_fours.to_i - @player_score.bat_fours.to_i
      @player.bat_sixes = @player.bat_sixes.to_i - @player_score.bat_sixes.to_i

      wickets = @player_score.bowl_wickets.to_i
      six_wickets = wickets / 6
      four_wickets = (wickets - six_wickets * 6) / 4
      @player.bowl_overs = @player.bowl_overs.to_i - @player_score.bowl_overs.to_i
      @player.bowl_maidens = @player.bowl_maidens.to_i - @player_score.bowl_maidens.to_i
      @player.bowl_runs = @player.bowl_runs.to_i - @player_score.bowl_runs.to_i
      @player.bowl_wickets = @player.bowl_wickets.to_i - wickets
      @player.bowl_4_wickets = @player.bowl_4_wickets.to_i - four_wickets
      @player.bowl_6_wickets = @player.bowl_6_wickets.to_i - six_wickets

      @player.field_catches = @player.field_catches.to_i - @player_score.field_catches.to_i
      @player.field_runouts = @player.field_runouts.to_i - @player_score.field_runouts.to_i
      @player.field_stumpings = @player.field_stumpings.to_i - @player_score.field_stumpings.to_i
      @player.field_drops = @player.field_drops.to_i - @player_score.field_drops.to_i

      @player.field_mom = @player.field_mom.to_i - 1 if @player_score.innings.match.mom = @player.id
      @player.save

      flash[:success] = "Player score record removed from Player #{@player.name}"
      redirect_to match_innings_player_scores_url(@match, @innings)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_player
      @player = Player.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def player_params
      params.require(:player).permit(:name, :age_category, :bat_innings,
        :bat_runs_scored, :bat_fifties, :bat_hundreds, :bat_ducks, :bat_not_outs,
        :bowl_overs, :bowl_runs, :bowl_wickets, :bowl_4_wickets, :bowl_6_wickets,
        :bowl_maidens, :field_catches, :field_runouts, :field_stumpings,
        :field_drops, :field_mom, :team, :match_id)
    end

    def admin_user
      redirect_to players_url, notice: "Only administrators are allowed to update the list of players." unless admin_user?
    end

    # From http://railscasts.com/episodes/228-sortable-table-columns?autoplay=true
    def sort_column
      Player.column_names.include?(params[:sort]) ? params[:sort] : "name"
    end
  
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

end
