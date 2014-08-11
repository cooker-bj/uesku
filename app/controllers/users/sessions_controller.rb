class Users::SessionsController < Devise::SessionsController
  respond_to :html
  layout :set_layout

  def create
    resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)
    respond_with resource do |format|
      format.html do 
       redirect_to after_sign_in_path_for(resource)
      end
      format.json do 
        render json: { auth_token: current_user.authentication_token }
      end
    end
  end

 
  
 
  protected
  def verified_request?
    request.content_type == "application/json" || super
  end
end
