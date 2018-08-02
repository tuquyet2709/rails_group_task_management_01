class AddTaskContentToReports < ActiveRecord::Migration[5.1]
  def change
    add_column :reports, :task_content, :string
    add_column :reports, :subtask_content, :string

  end
end
