class Users::OmniauthCallbacksController <Devise::OmniauthCallbacksController

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



  private
  def user_hash(access_token)
    data=access_token.extra.raw_info
    {
        :authenticated_tokens_attributes=>[{  provider:access_token.provider,
                                      uid: access_token.uid.to_s,
                                      access_token: access_token.credentials.token}],

        :real_name=>data['name'],
        :email=> data["email"],
        :gender=>  data['gender'],
        :birthday=> data['birthday'],
        :remote_avatar_url=> data['picture'],
        :password=>Devise.friendly_token[0,20]

    }
  end

end