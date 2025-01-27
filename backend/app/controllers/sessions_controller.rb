class SessionsController < ApplicationController
  include Authentication

  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def new
  end

  def create
    Rails.logger.debug "Authenticating user with: #{session_params}"
    user = User.find_by(email_address: session_params[:email_address].downcase)
    if user && user.authenticate(session_params[:password])
      start_new_session_for(user)
      redirect_url = user_path(user)
      Rails.logger.debug "Succses to authenticate user with:  #{session_params}"
      render json: { redirect_url: redirect_url }, status: :ok
    else
      Rails.logger.debug "Failed to authenticate user with: #{session_params}"
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end


  def destroy
    terminate_session
    redirect_to new_session_path ,status: :see_other
  end

  private
  def session_params
    params.require(:session).permit(:email_address, :password)
  end
end
