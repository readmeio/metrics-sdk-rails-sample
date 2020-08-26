class SessionsController < Devise::SessionsController
  acts_as_token_authentication_handler_for User, fallback_to_devise: false

  # POST /users/sign_in
  def create
    allow_params_authentication!
    self.resource = warden.authenticate!(auth_options)

    reset_token resource
    render json: resource
  end

  # DELETE /users/sign_out
  def destroy
    warden.authenticate!
    reset_token current_user
  end

  private

  def sign_in_params
    params.fetch(:user).permit([:password, :email])
  end

  def reset_token(resource)
    resource.authentication_token = nil
    resource.save!
  end
end
