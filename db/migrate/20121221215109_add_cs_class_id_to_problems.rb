class AddCsClassIdToProblems < ActiveRecord::Migration
  def change
    add_column :problems, :cs_class_id, :integer
  end
end
