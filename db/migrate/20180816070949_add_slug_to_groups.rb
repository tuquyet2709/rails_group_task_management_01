class AddSlugToGroups < ActiveRecord::Migration[5.1]
  def change
    add_column :groups, :slug, :string
  end
end
