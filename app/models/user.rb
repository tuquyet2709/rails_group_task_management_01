class User < ApplicationRecord
  attr_accessor :remember_token

  has_many :lead_groups, class_name: Group.name, foreign_key: "leader_id"
  has_many :group_members, foreign_key: "member_id"
  has_many :groups, through: :group_members, source: :group
  has_many :reports, foreign_key: "member_id"
  has_many :active_relationships, class_name: Relationship.name,
    foreign_key: "follower_id",
    dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :passive_relationships, class_name: Relationship.name,
    foreign_key: "followed_id",
    dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  before_save :downcase_email
  validates :name, presence: true,
    length: {maximum: Settings.maximum.length_name}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
    length: {maximum: Settings.maximum.length_email},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, presence: true,
    length: {minimum: Settings.minimum.length_pass},
    allow_nil: true

  enum role: {admin: 0, leader: 1, member: 2}

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attributes remember_digest: User.digest(remember_token)
  end

  def authenticated? remember_token
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update_attributes remember_digest: nil
  end

  private

  def downcase_email
    email.downcase!
  end
end
