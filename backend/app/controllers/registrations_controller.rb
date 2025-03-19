class RegistrationsController < ApplicationController
  allow_unauthenticated_access

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      start_new_session_for(@user)
      render json: { user: @user, redirect_url: user_path(@user) }, status: :created
    else
      render json: { 
        alert: @user.errors.full_messages.join(', '), 
        redirect_url: signup_path 
      }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email_address, :password, :password_confirmation)
  end
end