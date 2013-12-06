module Users::OmniauthCallbacksHelper
  def user_hash(access_token)
    data=access_token.extra.raw_info
    {
        :authenticated_tokens_attributes=>[{  provider:access_token.provider,
                                              uid: access_token.uid.to_s,
                                              access_token: access_token.credentials.token}],

        :real_name=>data['name'],
        :nickname=>data['nickname'],
        :email=> data["email"],
        :gender=>  User.get_gender(data['gender']),
        :birthday=> User.date_format(data['birthday']),
        :remote_avatar_url=> data['picture']||data['image']||data['figureurl_qq_1'],
        :password=>Devise.friendly_token[0,20]

    }
  end
end