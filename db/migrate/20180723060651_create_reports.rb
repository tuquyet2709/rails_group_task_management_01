class CreateReports < ActiveRecord::Migration[5.1]
  def change
    create_table :reports do |t|
      t.integer :member_id
      t.string :content

      t.timestamps
    end
    add_index :reports, :member_id
  end
end
