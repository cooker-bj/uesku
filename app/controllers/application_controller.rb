class ApplicationController < ActionController::Base
  protect_from_forgery
  include ApplicationHelper

  before_action :store_location
  before_action :set_variant
 
  
  after_action :user_activity

  def store_location
    session[:previous_url]=request.fullpath unless request.fullpath=~/\/users|\/comments$|\/admins|\.json/
  end

  def after_sign_in_path_for(resource)
    session[:previous_url]||root_user_path
  end
  
  protected
  def set_layout
   
     if request.get? && request.xhr?
       false
     else
       case request.user_agent
       when /iphone|android|windows phone|mobile/i
         "phone"
       else
         File.exist?("app/views/layouts/#{controller_name}.html.erb")? controller_name : "application"
       end
     end
  end
  
  private
  def user_activity
    current_user.try(:touch)
  end
  
  def set_variant
    request.variant=:phone if request.user_agent=~/iphone|Android|windows phone/i
    logger.info "request variant=!!!#{request.variant}"
  end
  
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
  

end
