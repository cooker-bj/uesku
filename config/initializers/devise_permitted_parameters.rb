module DevisePermittedParameters
  extend ActiveSupport::Concern
  
  
  included do 
    before_filter :configure_permitted_parameters
  end
  
  protected
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in) << :email
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:email,:password,:password_confirmation,:remember_me,:provider,:nickname,:real_name,:gender,:birthday,:avatar,:avatar_cache,:remote_avatar_url,{authenticated_tokens_attributes: [:uid,:provider,:access_token]},:location_id)
      
    end
    
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:email, :password, :password_confirmation, :remember_me,:provider,:nickname,:real_name,:gender,:birthday,:avatar,:avatar_cache,:remote_avatar_url,{authenticated_tokens_attributes: [:uid,:provider,:access_token]},:location_id)
      
    end
  end
end
DeviseController.send :include, DevisePermittedParameters