class ApplicationController < ActionController::Base
  protect_from_forgery
  include ApplicationHelper

  before_filter :store_location
  after_filter :user_activity

  def store_location
    session[:previous_url]=request.fullpath unless request.fullpath=~/\/users|\/comment$|\/admins/
  end

  def after_sign_in_path_for(resource)
    session[:previous_url]||root_path
  end
  private
  def user_activity
    current_user.try(:touch)
  end

end
