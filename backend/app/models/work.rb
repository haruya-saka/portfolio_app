class Work < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_many :work_images, dependent: :destroy

  # 作品のお気に入り情報
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user

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

  # いいね数を返す
  def favorite_count
    favorites.count
  end

  # Option: JSON出力にfavorite_countを含める場合
  def as_json(options = {})
    super(options).merge('favorite_count' => favorite_count)
  end
end

# filepath: /workspace/backend/app/models/work_image.rb
class WorkImage < ApplicationRecord
  belongs_to :work
  # 属性例: image_url, orientation など
end
