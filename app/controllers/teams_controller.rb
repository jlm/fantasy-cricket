class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy]
  before_action :signed_in_user, only: [:create, :edit, :update, :destroy]
  before_action :correct_user_for_team,   only: [:edit, :update, :destroy]

  # GET /teams
  # GET /teams.json
  def index
    @teams = Team.all
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
    @team = Team.find(params[:id])
    if params[:season].nil?
      @season = :thisseason
    else
      @season = params[:season].to_sym
    end
    unless @team.validated
      # meets_rules? is called for its side effect of setting error messages
      valid = @team.meets_rules?
      @team.errors.add(:teams, "must be validated before scores are applied")
    end
  end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # GET /teams/1/edit
  def edit
      if params[:season].nil?
      @season = :thisseason
    else
      @season = params[:season].to_sym
    end
end

  # POST /teams
  # POST /teams.json
  def create
    @team = current_user.teams.build(team_params)
    @team.name = @team.user.name + "'s team" if @team.name.nil?
    @team.totalscore = 0

    respond_to do |format|
      if @team.save
        format.html {
          flash[:success] = "Team created!"
  #        redirect_to user_path(current_user)
          redirect_to edit_team_path(@team)
        }
        format.json { render action: 'show', status: :created, location: @team }
      else
        format.html { render user_path(current_user) }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teams/1
  # PATCH/PUT /teams/1.json
  def update
    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to @team, notice: 'Team was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
    @team.destroy
    respond_to do |format|
      format.html { redirect_to teams_url }
      format.json { head :no_content }
    end
  end

  def add_player
    @team = Team.find(params[:id])
    @player = Player.find(params[:player])
    respond_to do |format|
      if @team.players.exists?(:id => @player.id)
        @team.errors.add(:player, "is already a member of #{@team.name}")
        format.html { redirect_to players_url, notice: "Player #{@player.name} is already a member of #{@team.name}" }
        format.js   { }
      else
        if @team.user.teamcash < @player.price
          @team.errors.add(:player, "is too expensive!  Remaining team cash is only £%0.1fm" % (@team.user.teamcash / 10.0))
          format.html { redirect_to players_url, notice: "Player #{@player.name} is too expensive!  Remaining team cash is only £%0.1fm" % (@team.user.teamcash / 10.0) }
          format.js   { }
        else
          @team.user.teamcash -= @player.price
          @team.players << @player
          @team.validated = false
          @team.save
          format.html {
            flash[:success] = "Player #{@player.name} has been added to #{@team.name}"
            redirect_to players_url
          }
          # Here's where to add a JavaScript responder which does nothing (see http://edgeguides.rubyonrails.org/working_with_javascript_in_rails.html)
          format.js   { }
          # And we'd need to create an app/views/teams/app_player.js.erb based on code from the first answer here: http://stackoverflow.com/questions/16045956/replacing-a-table-row-via-jquery
          # Only I'm not user if that should be app/views/teams or app/views/players.
        end
      end
    end
  end

  def remove_player
    @team = Team.find(params[:id])
    @player = Player.find(params[:player])
    respond_to do |format|
      if !@team.players.exists?(:id => @player.id)
        @team.errors.add(:player, "is not a member of #{@team.name}")
        format.html { redirect_to players_url, notice: "Player #{@player.name} is not a member of #{@team.name}" }
        format.js   { }
      else
        # This is where to credit the player's price to the user's account.
        @team.user.teamcash += @player.price
        # NB this delete operation does nothing if the player is not in the team.
        @team.players.delete(@player)
        @team.user.drop_available = false if @team.validated;
        @team.validated = false
        @team.captain_id = nil if @team.captain_id == @player.id
        @team.save
        raise @team.user.errors.full_messages.first unless @team.user.save
        format.html {
          flash[:success] = "Player #{@player.name} has been removed from #{@team.name}"
          redirect_to players_url
        }
        format.js   { }
      end
    end
  end

  def validate
    @team = Team.find(params[:id])
    if @team.meets_rules?
      @team.validated = true
      flash[:success] = "Team validated! Your team will now earn points"
    else
      flash[:warning] = "Team does not meet validation requirements"
    end
    raise "Can't save team in validate" unless @team.save
    redirect_to @team
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def team_params
      params.require(:team).permit(:name, :captain_id, :keeper_id)
    end

    # Before actions
  def correct_user_for_team
    team_ownwer = Team.find(params[:id]).user
    redirect_to(root_url) unless current_user?(team_ownwer) || admin_user?
  end


end
