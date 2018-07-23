class Subtask < ApplicationRecord
  belongs_to :task

  validate :task_id, presence: true
  validate :content, presence: true
  validate :done, presence: true
end
