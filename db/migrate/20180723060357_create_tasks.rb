class CreateTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :tasks do |t|
      t.string :content
      t.date :start_date
      t.date :end_date
      t.integer :group_id
      t.integer :member_id

      t.timestamps
    end
    add_index :tasks, :member_id
  end
end
