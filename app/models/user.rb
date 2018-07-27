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

  enum role: {admin: 0, leader: 1, member: 2}
  validates :role, presence: true
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

  scope :search_by_name,->(name){where("name like ? and role = ?",
                                       "%#{name}%",User.roles[:member])}

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

  def follow other_user
    following << other_user
  end

  def unfollow other_user
    following.delete other_user
  end

  def following? other_user
    following.include? other_user
  end

  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :member_id"
    Report.where("member_id IN (#{following_ids})
                     OR member_id = :member_id", member_id: id)
  end

  def in_group group
    GroupMember.where(group: group, user: self).blank?
  end

  private

  def downcase_email
    email.downcase!
  end
end
