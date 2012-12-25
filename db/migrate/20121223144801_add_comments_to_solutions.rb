class AddCommentsToSolutions < ActiveRecord::Migration
  def change
    add_column :solutions, :comments, :string
  end
end
