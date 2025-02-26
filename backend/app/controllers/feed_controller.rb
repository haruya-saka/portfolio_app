class FeedController < ApplicationController
  def index
    if current_user
      followed_ids = current_user.following.pluck(:id)
      works = Work.where(user_id: followed_ids).order(created_at: :desc).includes(:user)
    else
      works = []
    end

    render json: works.as_json(include: { user: { only: [:id, :name] } }, methods: [:thumbnail_url])
  end
end