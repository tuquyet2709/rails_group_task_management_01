class Group < ApplicationRecord
  has_many :group_members
  has_many :members, through: :group_members, source: :user
  has_many :tasks
  belongs_to :leader, class_name: User.name, foreign_key: "leader_id"
  validates :leader_id, presence: true
  validates :function, presence: true,
    length: {maximum: Settings.maximum.group_function}
  validates :description, presence: true,
    length: {maximum: Settings.maximum.group_description}
  mount_uploader :picture, PictureUploader
end
