class Subtask < ApplicationRecord
  belongs_to :task, optional: true

  validates :content, presence: true

  enum statuses: {not_started: 1, completed: 2}
end
