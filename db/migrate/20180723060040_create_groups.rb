class CreateGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :groups do |t|
      t.integer :leader_id

      t.timestamps
    end
  end
end
