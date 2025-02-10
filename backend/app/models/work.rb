class Work < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :title, presence: true

  def image_url
    Rails.application.routes.url_helpers.rails_blob_url(image, only_path: true) if image.attached?
  end
end
