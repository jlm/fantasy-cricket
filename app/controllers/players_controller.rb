class PlayersController < ApplicationController
  before_action :set_player, only: [:show, :edit, :update, :destroy]
  before_action :admin_user, only: [:new, :create, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token, :only => [:create]

  helper_method :sort_column, :sort_direction
  
  respond_to :js, :html, :json

  # GET /players
  # GET /players.json
  def index
    @players = Player.order(sort_column + " " + sort_direction).paginate(page: params[:page], per_page: 10)
    if params[:season].nil?
      @season = :thisseason
    else
      @season = params[:season].to_sym
    end
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
    @players = Player.order(sort_column + " " + sort_direction).paginate(page: params[:page], per_page: 10)
    if params[:season].nil?
      @season = :thisseason
    else
      @season = params[:season].to_sym
    end
    
    @player = Player.new(player_params)

    @player.field_mom = @player.field_mom.to_i

    respond_to do |format|
      if @player.save
        format.html { redirect_to @player, notice: 'Player was successfully created.' }
        format.json { render action: 'show', status: :created, location: @player }
        format.js { }
      else
        format.html { render action: 'new' }
        format.json { render json: @player.errors, status: :unprocessable_entity }
        format.js { }
      end
    end
  end

  # PATCH/PUT /players/1
  # PATCH/PUT /players/1.json
  def update
    #binding.pry
    @players = Player.order(sort_column + " " + sort_direction).paginate(page: params[:page], per_page: 10)
    if params[:season].nil?
      @season = :thisseason
    else
      @season = params[:season].to_sym
    end
    
    respond_to do |format|
      if @player.update(player_params)
        format.html { redirect_to @player, notice: 'Player was successfully updated.' }
        format.json { head :no_content }
        format.js { }
      else
        format.html { render action: 'edit' }
        format.json { render json: @player.errors, status: :unprocessable_entity }
        format.js { }
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
    applied = @player.player_scores.exists?(:id => @player_score.id)

    case request.request_method_symbol
    when :post
      if applied
        redirect_to match_innings_url(@match, @innings), notice: "Player #{@player.name} already has this player score applied"
        return
      else
        @player.player_scores << @player_score
        @player += @player_score      # apply the player_score record to the player
        success_message = "New player score attached to Player #{@player.name}"
        @player.teams.each do |team|
          team.player_scores << @player_score
          raise team.errors.full_messages.first unless team.save
        end
      end
    when :delete
      if !applied
        redirect_to match_innings_url(@match, @innings), notice: "Player #{@player.name} does not have this player score applied"
        return
      else
        @player.player_scores.delete(@player_score)
        @player -= @player_score      # unapply the player_score record to the player
        success_message = "Player score record removed from Player #{@player.name}"
        @player.teams.each do |team|
          team.player_scores.delete(@player_score)
          raise team.errors.full_messages.first unless team.save
        end
      end
    else
      raise 'Unexpected request method for apply_player_score'
    end
    if @player.save
      flash[:success] = success_message
    else
      raise @player.errors.full_messages.first
    end
    redirect_to match_innings_url(@match, @innings)
  end

=begin
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
      @player -= @player_score      # unapply the player_score record to the player
      if @player.save
        flash[:success] = "Player score record removed from Player #{@player.name}"
      else
        raise @player.errors.full_messages.first
      end
      redirect_to match_innings_url(@match, @innings)
    end
  end
=end

# This routine doesn't seem to work when you just invoke it from the console, but it works if you cut and paste the code.

  def transfer_season_scores
    Player.all.each do |player|
      player.ls_bat_innings = player.bat_innings
      player.ls_bat_runs_scored = player.bat_runs_scored
      player.ls_bat_fours = player.ls_bat_fours
      player.ls_bat_sixes = player.ls_bat_sixes
      player.ls_bat_fifties = player.bat_fifties
      player.ls_bat_hundreds = player.bat_hundreds
      player.ls_bat_ducks = player.bat_ducks
      player.ls_bat_not_outs = player.bat_not_outs
      player.ls_bowl_overs = player.bowl_overs
      player.ls_bowl_runs = player.bowl_runs
      player.ls_bowl_wickets = player.bowl_wickets
      player.ls_bowl_4_wickets = player.bowl_4_wickets
      player.ls_bowl_6_wickets = player.bowl_6_wickets
      player.ls_bowl_maidens = player.bowl_maidens
      player.ls_field_catches = player.field_catches
      player.ls_field_runouts = player.field_runouts
      player.ls_field_stumpings = player.field_stumpings
      player.ls_field_drops = player.field_drops
      player.ls_field_mom = player.field_mom
      player.ls_bat_score = player.bat_score
      player.ls_bowl_score = player.bowl_score
      player.ls_field_score = player.field_score
      player.ls_bonus = player.bonus
      player.ls_total = player.total
      player.ls_bat_avg = player.bat_avg
      player.ls_bowl_avg = player.bowl_avg
      player.ls_bat_avg_invalid = player.bat_avg_invalid
      player.ls_bowl_avg_invalid = player.bowl_avg_invalid

      player.bat_innings = 0
      player.bat_runs_scored = 0
      player.bat_fours = 0
      player.bat_sixes = 0
      player.bat_fifties = 0
      player.bat_hundreds = 0
      player.bat_ducks = 0
      player.bat_not_outs = 0
      player.bowl_overs = 0
      player.bowl_runs = 0
      player.bowl_wickets = 0
      player.bowl_4_wickets = 0
      player.bowl_6_wickets = 0
      player.bowl_maidens = 0
      player.field_catches = 0
      player.field_runouts = 0
      player.field_stumpings = 0
      player.field_drops = 0
      player.field_mom = 0
      player.bat_score = 0
      player.bowl_score = 0
      player.field_score = 0
      player.bonus = 0
      player.total = 0
      player.bat_avg = 0
      player.bowl_avg = 0
      player.bat_avg_invalid = true
      player.bowl_avg_invalid = true
      player.save
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_player
      @player = Player.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def player_params
      params.require(:player).permit(:name, :age_category, :player_category, :bat_innings,
        :bat_runs_scored, :bat_fifties, :bat_hundreds, :bat_ducks, :bat_not_outs,
        :bowl_overs, :bowl_runs, :bowl_wickets, :bowl_4_wickets, :bowl_6_wickets,
        :bowl_maidens, :field_catches, :field_runouts, :field_stumpings,
        :field_drops, :field_mom, :team, :match_id, :price)
    end

    def admin_user
      redirect_to players_url, notice: "Only administrators are allowed to update the list of players." unless admin_user? or Setting[:enable_uploads]
    end

    # From http://railscasts.com/episodes/228-sortable-table-columns?autoplay=true
    def sort_column
      Player.column_names.include?(params[:sort]) ? params[:sort] : "name"
    end
  
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

end
