class AddTaskKeyToTasks < ActiveRecord::Migration[5.1]
  def change
    add_column :tasks, :group_task_id, :integer
  end
end
