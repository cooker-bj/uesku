module ApplicationHelper
  def display_string(content,size)
    (content.length <size ? content : content[0,size-5]+'...' ) unless content.nil?
  end

  def set_city(city)
  session[:city]=city.id
  end

  def get_city
    session[:city]||2
  end

  def format_time(mytime)
    unless mytime.nil?
      mytime=mytime.localtime
      if mytime<1.year.ago
        mytime.strftime("%Y-%m-%d")

      elsif mytime< Time.now.yesterday
        mytime.strftime("%m-%d")
      else
        mytime.to_s(:time)
      end

    end
  end

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
        :remote_avatar_url=> data['picture']||data['image']||data['figureurl_qq-1'],
        :password=>Devise.friendly_token[0,20]

    }
  end
end
