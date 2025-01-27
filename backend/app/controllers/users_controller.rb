class UsersController < ApplicationController

  def show
    Rails.logger.debug "Rendering UsersController#show for user ID: #{params[:id]}"
    @user = User.find(params[:id])
  end
  
end
