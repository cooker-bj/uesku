class Admin::SessionsController<Devise::SessionsController
  # To change this template use File | Settings | File Templates.
  private
  def after_sign_out_path_for(resource_or_scope)
    admin_root_path
  end
end