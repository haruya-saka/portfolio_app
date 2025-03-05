class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :work

  validates :user_id, uniqueness: { scope: :work_id, message: "は同じ作品に対して複数のいいねを付けることはできません。" }
end