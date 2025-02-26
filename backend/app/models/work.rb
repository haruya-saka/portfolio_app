class Work < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_many :work_images, dependent: :destroy

  validates :title, :description, presence: true

  def image_url
    Rails.application.routes.url_helpers.rails_blob_url(image, only_path: true) if image.attached?
  end

  def thumbnail_url
    if image.attached?
      Rails.application.routes.url_helpers.rails_representation_url(
        image.variant(resize_to_limit: [300, 300]).processed,
        only_path: true
      )
    elsif work_images.any? && work_images.first.image_url.present?
      work_images.first.image_url
    end
  end
end

# filepath: /workspace/backend/app/models/work_image.rb
class WorkImage < ApplicationRecord
  belongs_to :work
  # 属性例: image_url, orientation など
end
