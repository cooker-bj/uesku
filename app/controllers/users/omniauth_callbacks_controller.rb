class Users::OmniauthCallbacksController <Devise::OmniauthCallbacksController
   include Users::OmniauthCallbacksHelper
  def google_oauth2
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_for_oauth2(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.omniauth"] = user_hash(request.env["omniauth.auth"])
      redirect_to new_user_registration_url
    end
  end

  def weibo
    google_oauth2
  end

  def qq_connect
   google_oauth2
  end





end