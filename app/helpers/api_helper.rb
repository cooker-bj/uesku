module ApiHelper
  def validate_auth_token
    self.resource = User.where('authentication_token=?',params[:user_token]).first
    render :status => 401, :json => {errors: [t('api.v1.token.invalid_token')]} if self.resource.nil?
  end
end
