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
    #binding.pry
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
    applied = @player.player_scores.exists?(:id => @player_score.id)

    case request.request_method_symbol
    when :post
      if applied
        redirect_to match_innings_url(@match, @innings), notice: "Player #{@player.name} already has this player score applied"
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
