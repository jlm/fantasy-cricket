class SettingsController < ApplicationController
  def index
    # to get all items for render list
    @settings = Setting.unscoped
    @tokens = Token.all
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

end
