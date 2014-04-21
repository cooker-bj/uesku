class ApiController < ActionController::Base
  # This is our new function that comes before Devise's one
  protect_from_forgery
  before_filter :authenticate_user_from_token!
  # This is Devise's authentication
  before_filter :authenticate_user!
 
 
  private
  
  def authenticate_user_from_token!
    user_email = params[:user_email].presence
    user       = user_email && User.where(:email=>user_email).first
 
    # Notice how we use Devise.secure_compare to compare the token
    # in the database with the token given in the params, mitigating
    # timing attacks.
    if user && Devise.secure_compare(user.authentication_token, params[:user_token])
      sign_in user, store: false
    else
      render :status => 401, :json => {errors: [t('api.v1.token.invalid_token')]}
    end
  end
end
