class Group < ApplicationRecord
  has_many :group_members
  has_many :members, through: :group_members, source: :user
  has_many :tasks
  belongs_to :leader, class_name: User.name, foreign_key: "leader_id"
  validates :leader_id, presence: true
end
