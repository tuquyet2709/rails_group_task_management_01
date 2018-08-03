class AddDoneTasksToTasks < ActiveRecord::Migration[5.1]
  def change
    add_column :tasks, :done_tasks, :integer
  end
end
