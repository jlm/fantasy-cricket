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
  end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # GET /teams/1/edit
  def edit
  end

  # POST /teams
  # POST /teams.json
  def create
    @team = current_user.teams.build(team_params)

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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def team_params
      params.require(:team).permit(:name)
    end

    # Before actions
  def correct_user_for_team
    team_ownwer = Team.find(params[:id]).user
    redirect_to(root_url) unless current_user?(team_ownwer) || admin_user?
  end


end
