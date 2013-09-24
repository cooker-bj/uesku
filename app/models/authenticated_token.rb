class AuthenticatedToken < ActiveRecord::Base
  attr_accessible :access_token, :provider, :uid, :user_id
  belongs_to :user
end
