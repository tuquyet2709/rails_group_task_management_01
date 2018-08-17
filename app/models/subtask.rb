class Subtask < ApplicationRecord
  belongs_to :task, optional: true
  belongs_to :user, optional: true

  validates :content, presence: true

  enum statuses: {not_started: 1, in_progress: 2, completed: 3}
end
