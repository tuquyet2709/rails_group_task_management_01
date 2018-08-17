class CreateTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :tasks do |t|
      t.string :content
      t.date :start_date
      t.date :end_date
      t.integer :group_id

      t.timestamps
    end
  end
end
