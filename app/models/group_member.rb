class GroupMember < ApplicationRecord
  belongs_to :user, foreign_key: "member_id"
  belongs_to :group, foreign_key: "group_id"

  validates :member_id, presence: true
  validates :group_id, presence: true
end
