class AddVisibleToProblems < ActiveRecord::Migration
  def change
    add_column :problems, :visible, :boolean
  end
end
