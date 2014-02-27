class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  helper_method :sort_column, :sort_direction

	def index
    @users = User.order(sort_column + " " + sort_direction).paginate(page: params[:page], per_page: 10)
  end

  def show
		@user = User.find(params[:id])
    redirect_to team_path(@user.teams.first) if @user.teams.any?
# 	    @teams = @user.teams.paginate(page: params[:page], per_page: 10)
    @team = current_user.teams.build if signed_in?

	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)
    @user.totalscore = 0
    @user.teamcash = INITIAL_TEAMCASH
    token = Token.find_by(tokenstr: @user.tokenstr)
    #binding.pry
    unless token and token.user_id.nil?
      flash[:warning] = "Sign-up token invalid. Please contact administrator"
      render 'new'
      return
    end      

		if @user.save
			sign_in @user
      token.user_id = @user.id
      token.save
      binding.pry
			flash[:success] = "Welcome to Helperby Fantasy Cricket!"
			redirect_to @user
		else
			render 'new'
		end
	end

  def edit
 #   @user = User.find(params[:id]) not needed now we user correct_user first
  end

  def update
#    @user = User.find(params[:id]) not needed now we user correct_user first
    params[:user].delete(:password) if params[:user][:password].blank?
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end


private

	def user_params
		params.require(:user).permit(:name, :email, :password,
			:password_confirmation, :tokenstr)
	end

    # From http://railscasts.com/episodes/228-sortable-table-columns?autoplay=true
    def sort_column
      User.column_names.include?(params[:sort]) ? params[:sort] : "totalscore"
    end
  
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end

end
