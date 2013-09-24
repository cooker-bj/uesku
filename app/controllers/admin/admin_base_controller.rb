class Admin::AdminBaseController  <ApplicationController
  layout 'backend'
  before_filter :authenticate_admin!
  load_and_authorize_resource
  rescue_from CanCan::AccessDenied do |exception|
    Rails.logger.debug "Access denied on #{exception.action} #{current_admin.email} #{exception.subject.inspect}"
    redirect_to root_url, :alert => exception.message
  end

  def current_ability
    @current_ability ||= AdminAbility.new(current_admin)
  end

  private

end