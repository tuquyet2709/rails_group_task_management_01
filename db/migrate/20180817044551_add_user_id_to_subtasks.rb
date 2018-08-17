class AddUserIdToSubtasks < ActiveRecord::Migration[5.1]
  def change
    add_column :subtasks, :user_id, :integer
    add_column :subtasks, :estimate, :integer
  end
end
