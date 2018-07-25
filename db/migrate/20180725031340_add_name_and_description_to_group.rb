class AddNameAndDescriptionToGroup < ActiveRecord::Migration[5.1]
  def change
    add_column :groups, :name, :string
    add_column :groups, :description, :string
  end
end
