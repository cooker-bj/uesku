class Users::RegistrationsController  < Devise::RegistrationsController

  def new
    if session['devise.omniauth'].present?
    build_resource(session['devise.omniauth'])

    else
      build_resource({})
      resource.authenticated_tokens.build
    end

    respond_with self.resource

  end

end