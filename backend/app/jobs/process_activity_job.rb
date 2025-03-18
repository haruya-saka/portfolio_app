class ProcessActivityJob < ApplicationJob
  queue_as :default

  def perform(activity_id)
    activity = Activity.find_by(id: activity_id)
    return unless activity

    score = activity.weight
    # 該当するInterestingScoreを排他制御して更新
    interesting_score = InterestingScore.find_or_create_by(subject_user: activity.performer, target_user: activity.target.user)
    interesting_score.with_lock do
      interesting_score.increment!(:score, score)
    end

    # 更新後、スコア更新に使用したactivityを削除
    activity.destroy
  end
end
