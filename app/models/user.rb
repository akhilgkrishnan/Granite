class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :name, presence: true, length: { maximum: 30 }
  has_many :tasks, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :user_notifications, dependent: :destroy, foreign_key: :user_id
  has_one  :preference, dependent: :destroy, foreign_key: :user_id

  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true, on: :create
  has_secure_token :authentication_token

  validates :email, presence: true,
                    uniqueness: true,
                    length: { maximum: 50 },
                    format: { with: VALID_EMAIL_REGEX }
  before_save :to_lowercase
  before_create :build_default_preference

  private

  def to_lowercase
    email.downcase!
  end

  def build_default_preference
    build_preference(notification_delivery_hour: Constants::DEFAULT_NOTIFICATION_DELIVERY_HOUR)
  end
end
