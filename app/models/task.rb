class Task < ApplicationRecord
  belongs_to :group
  has_many :subtasks, dependent: :destroy
  accepts_nested_attributes_for :subtasks,
    allow_destroy: true, reject_if: proc{|att| att["content"].blank?}

  validates :group_id, presence: true
  validates :content, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :title, presence: true
  validates :subtasks, presence: true
  validate :task_end_date

  scope :order_gti_asc, ->{order created_at: :desc}

  def task_end_date
    return if start_date.nil? || end_date.nil?
    return if start_date <= end_date
    errors.add :end_date, I18n.t("tasks.start_cant_later_than_end")
  end
end
