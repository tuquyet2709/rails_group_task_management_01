class Report < ApplicationRecord
  belongs_to :user, foreign_key: "member_id"

  validates :member_id, presence: true
  validates :content, presence: true
end
