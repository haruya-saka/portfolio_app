class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_one_attached :profile_image

  validates :name, presence: true
  validates :email_address, presence: true, uniqueness: true
  validate :validate_email
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?

  def profile_image_url
    profile_image.attached? ? Rails.application.routes.url_helpers.rails_blob_url(profile_image, only_path: true) : nil
  end
  
  private

  def validate_email
    unless email_address =~ /\A[^@\s]+@[^@\s]+\z/
      errors.add(:email_address, "is not a valid email")
    end
  end

  def password_required?
    new_record? || password.present?
  end
end