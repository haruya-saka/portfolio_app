class Work < ApplicationRecord
  belongs_to :user
  # 変更: has_one_attached :image -> has_many_attached :images
  has_many_attached :images
  has_many :work_images, dependent: :destroy

  validates :title, :description, presence: true

  def image_url
    if images.attached?
      # 最初の画像の URL を返す
      Rails.application.routes.url_helpers.rails_blob_url(images.first, only_path: true)
    end
  end
end

# filepath: /workspace/backend/app/models/work_image.rb
class WorkImage < ApplicationRecord
  belongs_to :work
  # 属性例: image_url, orientation など
end
