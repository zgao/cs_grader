class AddDeadlineToProblems < ActiveRecord::Migration
  def change
    add_column :problems, :due_date, :datetime
  end
end
