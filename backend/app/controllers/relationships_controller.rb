class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    user = User.find(params[:followed_id])
    current_user.follow(user)
    respond_to do |format|
      format.html { redirect_to user }
      format.js
      format.json { render json: { success: true } }
    end
  end

  def destroy
    user = User.find(params[:id])
    current_user.unfollow(user)
    respond_to do |format|
      format.html { redirect_to user, status: :see_other }
      format.json { render json: { success: true } }
    end
  end

  def find_by_user
    user = User.find(params[:user_id])
    is_following = current_user.following?(user)
    render json: { is_following: is_following }
  end
end
