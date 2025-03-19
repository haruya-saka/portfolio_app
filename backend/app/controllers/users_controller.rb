class UsersController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @users = User.all
    respond_to do |format|
      format.json { render json: @users }
    end
  end
  
  def show
    @user = User.find(params[:id])
    @user = User.find(params[:id]).as_json(only: [:id, :name, :description], methods: [:profile_image_url, :following_count, :followers_count])
    Rails.logger.debug "User JSON: #{@user.to_json}"  # デバッグ用ログ出力
    respond_to do |format|
      format.html # HTMLリクエストに対するレスポンス
      format.json { render json: @user } # JSONリクエストに対するレスポンス
    end
  end

  def update
    user = current_user
    if user.update(user_params)
      if params[:user][:profile_image].present?
        user.profile_image.purge # 既存のprofile_imageを削除
        user.profile_image.attach(params[:user][:profile_image])
        Rails.logger.debug "Profile image attached: #{user.profile_image.attached?}"
        if user.profile_image.attached?
          Rails.logger.debug "New Blob ID: #{user.profile_image.blob.id}"
        end
        Rails.logger.debug "Profile image URL: #{user.profile_image_url}"
      end
      render json: { redirect_url: user_path(user) }, status: :ok
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def edit
    @user = current_user
  end

  def following
    user = User.find(params[:id])
    following_users = user.following.as_json(only: [:id, :name], methods: [:profile_image_url])
    render json: { user: user.slice(:id, :name), following: following_users }
  end
  
  def followers
    user = User.find(params[:id])
    followers_users = user.followers.as_json(only: [:id, :name], methods: [:profile_image_url])
    render json: { user: user.slice(:id, :name), followers: followers_users }
  end

  private

  def authenticate_user!
    redirect_to login_path unless current_user
  end

  def user_params
    params.require(:user).permit(:name, :email, :profile_image, :description)
  end
end