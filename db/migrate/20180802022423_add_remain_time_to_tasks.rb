class AddRemainTimeToTasks < ActiveRecord::Migration[5.1]
  def change
    add_column :tasks, :remain_time, :datetime
  end
end
