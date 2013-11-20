class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  require 'digest/sha1'
  def make_id(str)
    sum = 0;
    Digest::SHA1.hexdigest(str).unpack('Q*').map do |a|
      sum = sum + a
    end
    sum
  end
end
