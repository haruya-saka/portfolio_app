class FeedController < ApplicationController
  def index
    if current_user
      followed_ids = current_user.following.pluck(:id)
      order_clause = if followed_ids.present?
                       "CASE WHEN user_id IN (#{followed_ids.join(',')}) THEN 0 ELSE 1 END, created_at DESC"
                     else
                       "created_at DESC"
                     end
      works = Work.all.order(Arel.sql(order_clause)).includes(:user)
      favorite_work_ids = current_user.favorites.pluck(:work_id)
    else
      works = []
      favorite_work_ids = []
    end

    render json: works.map { |work|
      work.as_json(
        include: { user: { only: [:id, :name], methods: [:profile_image_url] } },
        methods: [:thumbnail_url]
      ).merge({ is_favorited: favorite_work_ids.include?(work.id) })
    }
  end
end