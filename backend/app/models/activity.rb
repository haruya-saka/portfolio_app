class Activity < ApplicationRecord
  belongs_to :performer, class_name: "User"
  belongs_to :target, polymorphic: true

  # action_typeには "favorite", "unfavorite", "bookmark" などが入る
  validates :activity_type, presence: true
  
  # 各アクションのウェイト（unfavorite 用を追加）
  WEIGHTS = {
    'favorite'   => 1,
    'unfavorite' => -1
  }.freeze

  # 更新ジョブを実行
  after_create_commit do
    ProcessActivityJob.perform_later(id)
  end

  def weight
    WEIGHTS[activity_type] || 0
  end


  private
end