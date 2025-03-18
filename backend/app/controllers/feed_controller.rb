class FeedController < ApplicationController
  def index
    if current_user
      followed_ids = current_user.following.pluck(:id)
      interesting_user_ids = Activity.where(performer: current_user, activity_type: 'favorite', target_type: 'Work')
                                     .joins("INNER JOIN works ON activities.target_id = works.id")
                                     .pluck("works.user_id").uniq

      interesting_scores = InterestingScore.where(subject_user: current_user, target_user_id: followed_ids + interesting_user_ids)
                                           .pluck(:target_user_id, :score).to_h
      # CASE文の生成（interesting_scoresが空の場合は'0'を使用）
      interesting_case = if interesting_scores.any?
                           "CASE " + interesting_scores.map { |user_id, score| "WHEN user_id = #{user_id} THEN #{score}" }.join(' ') + " ELSE 0 END"
                         else
                           "0"
                         end

      order_clause = if followed_ids.any? || interesting_user_ids.any?
        "CASE 
          WHEN user_id IN (#{ interesting_user_ids.any? ? interesting_user_ids.join(',') : '-1' }) THEN 0 
          WHEN user_id IN (#{ followed_ids.any? ? followed_ids.join(',') : '-1' }) THEN 1 
          ELSE 2 
        END, 
        COALESCE(#{interesting_case}, 0) DESC, 
        created_at DESC"
      else
        "created_at DESC"
      end

      works = Work.all.order(Arel.sql(order_clause)).includes(:user)
    else
      works = []
    end

    render json: works.map { |work|
      work.as_json(
        include: { user: { only: [:id, :name], methods: [:profile_image_url] } },
        methods: [:thumbnail_url]
      ).merge({ is_favorited: current_user&.favorites&.pluck(:work_id)&.include?(work.id) })
    }
  end
end