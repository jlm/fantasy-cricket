class StaticPagesController < ApplicationController
  def home
  	if signed_in?
  		#render current_user and return
  		redirect_to current_user
  	end
  end

  def admin
    case request.request_method_symbol
    when :post
      
    when :delete
    end
  end

  def help
  end

  def about
  end
end
