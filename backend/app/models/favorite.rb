class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :work

  validates :user_id, uniqueness: { scope: :work_id, message: "は同じ作品に対して複数のいいねを付けることはできません。" }

  after_create_commit :create_activity
  after_destroy_commit :destroy_activity

  private

  def create_activity
    Activity.create(performer: user, target: work, activity_type: 'favorite')
  end

  def destroy_activity
    Activity.create(performer: user, target: work, activity_type: 'unfavorite')
  end
end