# filepath: app/models/interesting_score.rb
class InterestingScore < ApplicationRecord
  belongs_to :subject_user, class_name: "User"
  belongs_to :target_user, class_name: "User"

  # 今後必要に応じたメソッドやバリデーションを追加可能
  validates :subject_user_id, uniqueness: { scope: :target_user_id }
end