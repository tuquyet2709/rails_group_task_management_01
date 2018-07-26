class Report < ApplicationRecord
  belongs_to :user, foreign_key: "member_id"
  scope :order_desc, ->{order created_at: :desc}

  validates :member_id, presence: true
  validates :content, presence: true
end
