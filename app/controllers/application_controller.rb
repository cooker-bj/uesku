class ApplicationController < ActionController::Base
  protect_from_forgery
  include ApplicationHelper

  before_filter :store_location,:authenticate_user!
  after_filter :user_activity

  def store_location
    session[:previous_url]=request.fullpath unless request.fullpath=~/\/users|\/comments$|\/admins/
  end

  def after_sign_in_path_for(resource)
    session[:previous_url]||root_path
  end
  private
  def user_activity
    current_user.try(:touch)
  end

end
