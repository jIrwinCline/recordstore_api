class SigninController < ApplicationController
  before_action :authorize_access_request!, only: [:destroy]

  def created
    user = User.find_by(email: params[:email])

    if iser.authenticate(params[:password])
      payload = { user_id: user.id }
      session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
      tokens = session.login

      render json: { crsf: tokens[:crsf] }
    else
      not_authorized
    end
  end

  def destroy
    session = JWTSessions::Session.new(payload: payload)
    session.flush_by_by_access_payload
    render json: :ok
  end

  private

  def not_found
    render json: { error: 'Cannot find email/password combination'}, status: :not_found
  end
end
