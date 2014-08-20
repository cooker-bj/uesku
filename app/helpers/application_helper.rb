module ApplicationHelper

 
  def display_string(content,size)
    (content.length <size ? content : content[0,size-5]+'...' ) unless content.nil?
  end

  def set_city_in_session(city)
  session[:city]=city.id
  end

  def get_city
    session[:city]||Ipaddress.find(request.remote_ip).try(:id) || 110100
  end

  def get_city_name
    Location.find(get_city).try(:name)
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

  

  def hour_array
    array=[]
    (0..23).each do |hour|
      array<< ("%02d" % hour)
    end
    array
  end

  def minute_array
    array=[]
    (0..59).each do |minute|
      array<<("%02d" % minute)
    end
    array
  end

  def url_with_protocol(url)
    /^http/.match(url) ? url : "http://#{url}"
  end

  def whodoit(id)
    User.find(id.to_i) unless id.nil?
  end
  
  def mobile_page_id(path=request.fullpath)
    n= current_user.nil? ? path.gsub("/",'_') : current_user.id.to_s+path.gsub('/','_')
    logger.info "!!! page id=#{n}"
    n
  end  
  



end
