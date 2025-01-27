class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  validates :name, presence: true
  validates :email_address, presence: true, uniqueness: true
  validate :validate_email
  validates :password, presence: true, length: { minimum: 6 }


  private

  def validate_email
    unless email_address =~ /\A[^@\s]+@[^@\s]+\z/
      errors.add(:email_address, "is not a valid email")
    end
  end
end