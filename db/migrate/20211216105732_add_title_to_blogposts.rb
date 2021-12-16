class AddTitleToBlogposts < ActiveRecord::Migration[6.1]
  def change
    add_column :blogposts, :title, :string
    add_column :blogposts, :content, :text
    add_column :blogposts, :date, :date
  end
end
