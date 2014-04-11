class SettingsController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_action :admin_user

  def index
    # to get all items for render list
    @settings = Setting.unscoped
    @tokens = Token.order(sort_column + " " + sort_direction).paginate(page: params[:page], per_page: 5)
  end

  def edit
    @setting = Setting.unscoped.find(params[:id])
  end

  def show
  end

  def update
  	@setting = Setting.unscoped.find(params[:id])
  	case params[:value]
  	when "true"
  		@setting.value = true
  	when "false"
  		@setting.value = false
  	else
  		@setting.value = params[:value]
  	end
  	@setting.save
  	redirect_to '/settings'
  end

  def toggle
  	@setting = Setting.unscoped.find(params[:id])
  	@setting.value = !@setting.value
  	@setting.save
  	#binding.pry
  	User.update_all("drop_available = true") if @setting[:var] == "enable_changes" and @setting.value
  	redirect_to '/settings'
  end

  private
    # From http://railscasts.com/episodes/228-sortable-table-columns?autoplay=true
    def sort_column
      Token.column_names.include?(params[:sort]) ? params[:sort] : "ticketno"
    end
  
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end

end
