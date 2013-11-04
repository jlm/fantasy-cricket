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
  end

  # GET /players/1/edit
  def edit
  end

  # POST /players
  # POST /players.json
  def create
    @player = Player.new(player_params)

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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_player
      @player = Player.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def player_params
      params.require(:player).permit(:name, :age_category, :bat_innings, :bat_runs_scored, :bat_fifties, :bat_hundreds, :bat_ducks, :bat_not_outs, :bowl_overs, :bowl_runs, :bowl_wickets, :bowl_4_wickets, :bowl_6_wickets, :bowl_maidens, :field_catches, :field_runouts, :field_stumpings, :field_drops, :field_mom, :team)
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
