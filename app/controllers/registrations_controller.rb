class RegistrationsController < Devise::RegistrationsController
  acts_as_token_authentication_handler_for User

  # POST /users
  def create
    build_resource(sign_up_params)

    if resource.save
      sign_up(resource_name, resource)
      render json: resource, status: :created
    else
      clean_up_passwords resource
      head :unprocessable_entity
    end
  end

  private

  def sign_up_params
    params.fetch(:user).permit([:password, :password_confirmation, :email, :name])
  end
end
