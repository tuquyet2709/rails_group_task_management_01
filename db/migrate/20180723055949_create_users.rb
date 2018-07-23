class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.boolean :admin
      t.boolean :activated
      t.string :password_digest
      t.string :remember_digest
      t.integer :role

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
