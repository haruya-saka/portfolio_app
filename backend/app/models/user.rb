class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_one_attached :profile_image
  has_many :works, dependent: :destroy

  has_many :active_relationships, class_name: "Relationship", 
                                  foreign_key: "follower_id", 
                                  dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed

  has_many :passive_relationships, class_name: "Relationship", 
                                  foreign_key: "followed_id", 
                                  dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  validates :name, presence: true
  validates :email_address, presence: true, uniqueness: true
  validate :validate_email
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?

  def profile_image_url
    profile_image.attached? ? Rails.application.routes.url_helpers.rails_blob_url(profile_image, only_path: true) : nil
  end

  def following_count
    following.count
  end

  def followers_count
    followers.count
  end

  def follow(other_user)
    return if self == other_user  # 自分自身はフォローできない
    active_relationships.create(followed_id: other_user.id)
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id)&.destroy
  end

  def following?(other_user)
    following.include?(other_user)
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