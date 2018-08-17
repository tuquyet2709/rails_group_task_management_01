class CreateSubtasks < ActiveRecord::Migration[5.1]
  def change
    create_table :subtasks do |t|
      t.integer :task_id
      t.string :content
      t.integer :done

      t.timestamps
    end
  end
end
