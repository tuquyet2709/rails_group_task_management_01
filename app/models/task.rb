class Task < ApplicationRecord
  belongs_to :group
  has_many :subtasks

  validates :group_id, presence: true
  validates :member_id, presence: true
  validates :content, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
end
